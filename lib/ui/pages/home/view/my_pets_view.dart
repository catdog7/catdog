import 'dart:io';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/pet_dependency.dart';
import 'package:catdog/domain/model/pet_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// 동물 카드 데이터 클래스 (수정 가능)
class _PetCardData {
  final String id;
  final TextEditingController nameController;
  final TextEditingController ageController;
  String selectedSpecies;
  DateTime? selectedBirthDate;
  XFile? selectedImage;
  String? existingImageUrl;
  bool isAgeUnknown;
  bool isNew;
  bool isExpanded;
  bool isSelected; // 삭제 모드에서 선택 여부

  _PetCardData({
    required this.id,
    required this.nameController,
    required this.ageController,
    required this.selectedSpecies,
    this.selectedBirthDate,
    this.selectedImage,
    this.existingImageUrl,
    this.isAgeUnknown = false,
    this.isNew = false,
    this.isExpanded = true,
    this.isSelected = false,
  });

  factory _PetCardData.fromPetModel(PetModel pet) {
    final nameController = TextEditingController(text: pet.name);
    final ageController = TextEditingController();

    if (pet.birthDatePrecision == 'UNKNOWN') {
      ageController.text = '모름';
    } else if (pet.birthDate != null) {
      ageController.text = DateFormat('yyyy년 M월 d일').format(pet.birthDate!);
    }

    return _PetCardData(
      id: pet.id,
      nameController: nameController,
      ageController: ageController,
      selectedSpecies: pet.species,
      selectedBirthDate: pet.birthDate,
      existingImageUrl: pet.image2dUrl,
      isAgeUnknown: pet.birthDatePrecision == 'UNKNOWN',
      isNew: false,
      isExpanded: true,
      isSelected: false,
    );
  }
}

class MyPetsView extends ConsumerStatefulWidget {
  const MyPetsView({super.key});

  @override
  ConsumerState<MyPetsView> createState() => _MyPetsViewState();
}

class _MyPetsViewState extends ConsumerState<MyPetsView> {
  List<_PetCardData> _petCards = [];
  final _uuid = const Uuid();
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isDeleteMode = false; // 삭제 모드
  bool isPicking = false; // imagePicker 중복 클릭 방지

  int get _selectedCount => _petCards.where((c) => c.isSelected).length;

  @override
  void initState() {
    super.initState();
    _loadPets();

    //화면 진입 로그
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'My_Pets_View',
      screenClass: 'MyPetsView',
    );
  }

  @override
  void dispose() {
    for (var card in _petCards) {
      card.nameController.dispose();
      card.ageController.dispose();
    }
    super.dispose();
  }

  Future<void> _loadPets() async {
    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final pets = await ref.read(petUseCaseProvider).getMyPets(userId);
      setState(() {
        _petCards = pets.map((pet) => _PetCardData.fromPetModel(pet)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('_loadPets error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _toggleCard(String id) {
    setState(() {
      final index = _petCards.indexWhere((card) => card.id == id);
      if (index != -1) {
        _petCards[index].isExpanded = !_petCards[index].isExpanded;
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      final index = _petCards.indexWhere((card) => card.id == id);
      if (index != -1) {
        _petCards[index].isSelected = !_petCards[index].isSelected;
      }
    });
  }

  void _addPetCard() {
    setState(() {
      _petCards.add(
        _PetCardData(
          id: _uuid.v4(),
          nameController: TextEditingController(),
          ageController: TextEditingController(),
          selectedSpecies: 'DOG',
          selectedBirthDate: null,
          selectedImage: null,
          isAgeUnknown: false,
          isNew: true,
          isExpanded: true,
        ),
      );
    });
  }

  void _removePetCard(String id) {
    setState(() {
      final index = _petCards.indexWhere((card) => card.id == id);
      if (index != -1) {
        final card = _petCards[index];
        card.nameController.dispose();
        card.ageController.dispose();
        _petCards.removeAt(index);
      }
    });
  }

  Future<void> _pickImage(_PetCardData cardData) async {
    if (isPicking) return;
    try {
      isPicking = true;
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          cardData.selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint("이미지 피커 에러: $e");
    } finally {
      isPicking = false;
    }
  }

  Future<void> _selectBirthDate(_PetCardData cardData) async {
    DateTime tempDate = cardData.selectedBirthDate ?? DateTime.now();
    bool tempIsAgeUnknown = cardData.isAgeUnknown;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 360,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('년', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 60),
                        Text('월', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 60),
                        Text('일', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: tempDate,
                      minimumDate: DateTime(1900),
                      maximumDate: DateTime.now(),
                      onDateTimeChanged: (date) {
                        tempDate = date;
                        setModalState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        setModalState(() {
                          tempIsAgeUnknown = !tempIsAgeUnknown;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: tempIsAgeUnknown,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (value) {
                              setModalState(() {
                                tempIsAgeUnknown = value ?? false;
                              });
                            },
                          ),
                          const Text('나이 모름', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      MediaQuery.of(context).padding.bottom + 20,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF2F2F2),
                              foregroundColor: const Color(0xFFA9A9A9),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('취소'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFDCA40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                if (tempIsAgeUnknown) {
                                  cardData.selectedBirthDate = null;
                                  cardData.isAgeUnknown = true;
                                  cardData.ageController.text = '모름';
                                } else {
                                  cardData.selectedBirthDate = tempDate;
                                  cardData.isAgeUnknown = false;
                                  cardData.ageController.text = DateFormat(
                                    'yyyy년 M월 d일',
                                  ).format(tempDate);
                                }
                              });
                              Future.microtask(() {
                                Navigator.pop(context);
                              });
                            },
                            child: const Text(
                              '확인',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _savePets() async {
    // 모든 카드 검증
    for (var card in _petCards) {
      if (card.nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('모든 반려동물 이름을 입력해주세요.')));
        return;
      }
      if (card.selectedBirthDate == null && !card.isAgeUnknown) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('모든 반려동물 나이를 선택해주세요.')));
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('로그인이 필요합니다.');
      }

      for (var card in _petCards) {
        String? imageUrl = card.existingImageUrl;

        if (card.selectedImage != null) {
          try {
            final fileName =
                "${DateTime.now().millisecondsSinceEpoch}_${card.id}.jpg";
            final bytes = await card.selectedImage!.readAsBytes();
            await client.storage
                .from("pet_image")
                .uploadBinary(fileName, bytes);
            imageUrl = client.storage.from('pet_image').getPublicUrl(fileName);
          } catch (e) {
            print('Image upload error: $e');
          }
        }

        final pet = PetModel(
          id: card.id,
          userId: userId,
          name: card.nameController.text.trim(),
          species: card.selectedSpecies,
          birthDate: card.selectedBirthDate,
          birthDatePrecision: card.isAgeUnknown ? 'UNKNOWN' : 'EXACT',
          image2dUrl: imageUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (card.isNew) {
          await ref.read(petUseCaseProvider).addPet(pet);
          card.isNew = false;
        } else {
          await ref.read(petUseCaseProvider).updatePet(pet);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('저장되었습니다.')));
      }
    } catch (e) {
      print('Pet save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteSelectedPets() async {
    final selectedPets = _petCards.where((c) => c.isSelected).toList();
    if (selectedPets.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      for (var card in selectedPets) {
        if (!card.isNew) {
          await ref.read(petUseCaseProvider).removePet(card.id);
        }
        card.nameController.dispose();
        card.ageController.dispose();
      }

      setState(() {
        _petCards.removeWhere((c) => c.isSelected);
        _isDeleteMode = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${selectedPets.length}마리가 삭제되었습니다.')),
        );
      }
    } catch (e) {
      print('Pet delete error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _exitDeleteMode() {
    setState(() {
      _isDeleteMode = false;
      for (var card in _petCards) {
        card.isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              // 상단 헤더
              _Header(
                onClose: () => Navigator.of(context).pop(),
                isDeleteMode: _isDeleteMode,
                selectedCount: _selectedCount,
                onDeletePressed: _isDeleteMode
                    ? _deleteSelectedPets
                    : () {
                        setState(() => _isDeleteMode = true);
                      },
                onCancelDelete: _exitDeleteMode,
              ),

              // 카드 영역
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _petCards.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '등록된 반려동물이 없습니다.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _addPetCard,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFDCA40),
                              ),
                              child: const Text(
                                '반려동물 추가',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              ..._petCards.asMap().entries.map((entry) {
                                final index = entry.key;
                                final cardData = entry.value;

                                // 삭제 모드: 컴팩트 카드
                                if (_isDeleteMode) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _CompactPetCard(
                                      cardData: cardData,
                                      onToggleSelection: () =>
                                          _toggleSelection(cardData.id),
                                    ),
                                  );
                                }

                                // 기본 모드: 전체 폼 카드
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: _PetFormCard(
                                    cardIndex: index + 1,
                                    cardData: cardData,
                                    onToggle: () => _toggleCard(cardData.id),
                                    onSpeciesChanged: (species) {
                                      setState(() {
                                        cardData.selectedSpecies = species;
                                      });
                                    },
                                    onBirthDateTap: () =>
                                        _selectBirthDate(cardData),
                                    onImageTap: () => _pickImage(cardData),
                                    onImageRemove: () {
                                      setState(() {
                                        cardData.selectedImage = null;
                                        cardData.existingImageUrl = null;
                                      });
                                    },
                                    showRemoveButton: cardData.isNew,
                                    onRemove: () => _removePetCard(cardData.id),
                                  ),
                                );
                              }),

                              // 추가하기 버튼 (삭제 모드가 아닐 때만)
                              if (!_isDeleteMode)
                                _AddButton(onPressed: _addPetCard),
                            ],
                          ),
                        ),
                      ),
              ),

              // 완료 버튼 (삭제 모드가 아닐 때만)
              if (!_isDeleteMode && _petCards.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: _CompleteButton(
                    isLoading: _isSaving,
                    onPressed: _savePets,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------- Header -------------------- */
class _Header extends StatelessWidget {
  final VoidCallback onClose;
  final bool isDeleteMode;
  final int selectedCount;
  final VoidCallback onDeletePressed;
  final VoidCallback onCancelDelete;

  const _Header({
    required this.onClose,
    required this.isDeleteMode,
    required this.selectedCount,
    required this.onDeletePressed,
    required this.onCancelDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Color(0xFF1C1B1F),
              ),
              onPressed: isDeleteMode ? onCancelDelete : onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const Text(
              '내 반려동물',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1B1F),
              ),
            ),
            GestureDetector(
              onTap: onDeletePressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isDeleteMode && selectedCount > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDCA40),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$selectedCount',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    '삭제',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDeleteMode && selectedCount > 0
                          ? Colors.red
                          : const Color(0xFF1C1B1F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------- Compact Pet Card (Delete Mode) -------------------- */
class _CompactPetCard extends StatelessWidget {
  final _PetCardData cardData;
  final VoidCallback onToggleSelection;

  const _CompactPetCard({
    required this.cardData,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        cardData.selectedImage != null ||
        (cardData.existingImageUrl != null &&
            cardData.existingImageUrl!.isNotEmpty);

    return GestureDetector(
      onTap: onToggleSelection,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardData.isSelected ? const Color(0xFFFFF4D7) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: cardData.isSelected
                ? const Color(0xFFFDCA40)
                : Colors.black12,
          ),
        ),
        child: Row(
          children: [
            // 동그란 프로필 이미지
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                image: hasImage
                    ? DecorationImage(
                        image: cardData.selectedImage != null
                            ? FileImage(File(cardData.selectedImage!.path))
                            : NetworkImage(cardData.existingImageUrl!)
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !hasImage
                  ? Icon(
                      cardData.selectedSpecies == 'DOG'
                          ? Icons.pets
                          : Icons.pets,
                      color: Colors.grey.shade400,
                      size: 24,
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // 이름
            Expanded(
              child: Text(
                cardData.nameController.text.isEmpty
                    ? '이름 없음'
                    : cardData.nameController.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1C1B1F),
                ),
              ),
            ),

            // 체크박스
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cardData.isSelected
                      ? const Color(0xFFFDCA40)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: cardData.isSelected
                    ? const Color(0xFFFDCA40)
                    : Colors.transparent,
              ),
              child: cardData.isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------- Pet Form Card -------------------- */
class _PetFormCard extends StatelessWidget {
  final int cardIndex;
  final _PetCardData cardData;
  final VoidCallback onToggle;
  final Function(String) onSpeciesChanged;
  final VoidCallback onBirthDateTap;
  final VoidCallback onImageTap;
  final VoidCallback onImageRemove;
  final bool showRemoveButton;
  final VoidCallback? onRemove;

  const _PetFormCard({
    required this.cardIndex,
    required this.cardData,
    required this.onToggle,
    required this.onSpeciesChanged,
    required this.onBirthDateTap,
    required this.onImageTap,
    required this.onImageRemove,
    required this.showRemoveButton,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '댕냥 $cardIndex',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1B1F),
                ),
              ),
              if (showRemoveButton && onRemove != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              else
                IconButton(
                  icon: AnimatedRotation(
                    turns: cardData.isExpanded ? 0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_up, size: 24),
                  ),
                  onPressed: onToggle,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          // 확장된 콘텐츠
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(context),
            crossFadeState: cardData.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // 강아지 / 고양이 선택
        Row(
          children: [
            _PetType(
              isSelected: cardData.selectedSpecies == 'DOG',
              label: '강아지',
              onTap: () => onSpeciesChanged('DOG'),
            ),
            const SizedBox(width: 20),
            _PetType(
              isSelected: cardData.selectedSpecies == 'CAT',
              label: '고양이',
              onTap: () => onSpeciesChanged('CAT'),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 이름 입력
        _InputField(label: '반려동물 이름', controller: cardData.nameController),
        const SizedBox(height: 24),

        // 나이 선택
        _InputField(
          label: '반려동물 나이',
          controller: cardData.ageController,
          trailing: Icons.keyboard_arrow_down,
          onTap: onBirthDateTap,
        ),

        const SizedBox(height: 24),

        // 이미지 등록
        _buildImageSection(context),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final hasExistingImage =
        cardData.existingImageUrl != null &&
        cardData.existingImageUrl!.isNotEmpty;
    final hasNewImage = cardData.selectedImage != null;
    final hasImage = hasNewImage || hasExistingImage;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '반려동물 대표사진',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1B1F),
              ),
            ),
            GestureDetector(
              onTap: onImageTap,
              child: Container(
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                child: const Text(
                  '이미지 등록하기',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        if (hasImage)
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 8,
                  top: 0,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: hasNewImage
                            ? FileImage(File(cardData.selectedImage!.path))
                            : NetworkImage(cardData.existingImageUrl!)
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -12,
                  right: 2,
                  child: GestureDetector(
                    onTap: onImageRemove,
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            child: Center(
              child: Image.asset(
                'assets/icon/photo_camera.webp',
                width: 19,
                height: 19,
              ),
            ),
          ),
      ],
    );
  }
}

/* -------------------- Components -------------------- */

class _PetType extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback? onTap;

  const _PetType({required this.isSelected, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.20,
                  color: isSelected
                      ? const Color(0xFFFDCA40)
                      : const Color(0xFFDDDFE3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isSelected
                ? Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const ShapeDecoration(
                      color: Color(0xFFFCBB0C),
                      shape: OvalBorder(),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              color: Color(0xFF1C1B1F),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final IconData? trailing;
  final VoidCallback? onTap;

  const _InputField({
    required this.label,
    this.controller,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1C1B1F),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap != null
              ? () {
                  FocusScope.of(context).unfocus();
                  onTap?.call();
                }
              : null,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black26),
            ),
            child: Row(
              children: [
                Expanded(
                  child: controller != null
                      ? TextField(
                          controller: controller,
                          maxLength: label == '반려동물 이름' ? 20 : null,
                          readOnly: label == '반려동물 나이',
                          showCursor: label != '반려동물 나이',
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            counterText: label == '반려동물 이름' ? '' : null,
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1C1B1F),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                if (trailing != null) Icon(trailing, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/* -------------------- Buttons -------------------- */

class _AddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFF4D7),
        foregroundColor: const Color(0xFF1C1B1F),
        minimumSize: const Size(double.infinity, 46),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: Color(0xFFFCCC0D)),
        ),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: const Text(
        '추가하기',
        style: TextStyle(
          fontSize: 15,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1B1F),
        ),
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _CompleteButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFDCA40),
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : const Text(
              '완료',
              style: TextStyle(
                color: Color(0xFF1C1B1F),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
