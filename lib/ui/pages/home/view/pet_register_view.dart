import 'dart:io';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/pet_dependency.dart';
import 'package:catdog/domain/model/pet_model.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:catdog/ui/pages/home/view/pet_edit_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class _PetCardData {
  final String id;
  final TextEditingController nameController;
  final TextEditingController ageController;
  String selectedSpecies;
  DateTime? selectedBirthDate;
  XFile? selectedImage;
  String? existingImageUrl;
  bool isAgeUnknown;
  bool isExisting;

  _PetCardData({
    required this.id,
    required this.nameController,
    required this.ageController,
    required this.selectedSpecies,
    this.selectedBirthDate,
    this.selectedImage,
    this.existingImageUrl,
    this.isAgeUnknown = false,
    this.isExisting = false,
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
      isExisting: true,
    );
  }
}

class PetRegisterView extends ConsumerStatefulWidget {
  const PetRegisterView({super.key});

  @override
  ConsumerState<PetRegisterView> createState() => _PetRegisterViewState();
}

class _PetRegisterViewState extends ConsumerState<PetRegisterView> {
  List<_PetCardData> _petCards = [];
  final _uuid = const Uuid();
  bool _isLoading = false;
  bool _isInitialLoading = true;
  bool isPicking = false; // 이미지 피커 중복 클릭 방지

  @override
  void initState() {
    super.initState();
    _loadExistingPets();

    //화면 진입 로그 기록
    FirebaseAnalytics.instance.logScreenView(
      screenName: 'Pet_Register_View',
      screenClass: 'PetRegisterView',
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

  Future<void> _loadExistingPets() async {
    final client = ref.read(supabaseClientProvider);
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        _isInitialLoading = false;
        if (_petCards.isEmpty) {
          _petCards.add(
            _PetCardData(
              id: 'new_1',
              nameController: TextEditingController(),
              ageController: TextEditingController(),
              selectedSpecies: 'DOG',
              selectedBirthDate: null,
              selectedImage: null,
              isAgeUnknown: false,
              isExisting: false,
            ),
          );
        }
      });
      return;
    }

    try {
      final pets = await ref.read(petUseCaseProvider).getMyPets(userId);
      setState(() {
        _petCards = pets.map((pet) => _PetCardData.fromPetModel(pet)).toList();
        _isInitialLoading = false;
      });
    } catch (e) {
      debugPrint('_loadExistingPets error: $e');
      setState(() {
        _isInitialLoading = false;
        if (_petCards.isEmpty) {
          _petCards.add(
            _PetCardData(
              id: 'new_1',
              nameController: TextEditingController(),
              ageController: TextEditingController(),
              selectedSpecies: 'DOG',
              selectedBirthDate: null,
              selectedImage: null,
              isAgeUnknown: false,
              isExisting: false,
            ),
          );
        }
      });
    }
  }

  void _addPetCard() {
    //카드 추가 이벤트 기록
    FirebaseAnalytics.instance.logEvent(
      name: 'add_pet_card_clicked',
      parameters: {'current_card_count': _petCards.length},
    );
    setState(() {
      _petCards.add(
        _PetCardData(
          id: 'new_${DateTime.now().millisecondsSinceEpoch}',
          nameController: TextEditingController(),
          ageController: TextEditingController(),
          selectedSpecies: 'DOG',
          selectedBirthDate: null,
          selectedImage: null,
          isAgeUnknown: false,
          isExisting: false,
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

        if (card.isExisting) {
          ref.read(petUseCaseProvider).removePet(card.id).catchError((e) {
            debugPrint('Pet delete error: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('동물 삭제 중 오류가 발생했습니다.')),
            );
          });
        }

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
      debugPrint("에러 발생: $e");
    } finally {
      isPicking = false;
    }
  }

  Future<void> _selectBirthDate(_PetCardData cardData) async {
    DateTime tempDate = cardData.selectedBirthDate ?? DateTime.now();
    bool tempIsAgeUnknown = cardData.isAgeUnknown;
    // 초기값 설정
    if (cardData.isAgeUnknown) {
      cardData.ageController.text = '모름';
    } else if (cardData.selectedBirthDate != null) {
      cardData.ageController.text = DateFormat(
        'yyyy년 M월 d일',
      ).format(cardData.selectedBirthDate!);
    }

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
                              side: BorderSide.none,
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

  Future<void> _savePet() async {
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

    setState(() => _isLoading = true);

    try {
      final client = ref.read(supabaseClientProvider);
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('로그인이 필요합니다.');
      }
      //등록 시도 로그
      FirebaseAnalytics.instance.logEvent(
        name: 'pet_registration_attempt',
        parameters: {
          'pet_count': _petCards.length,
          'has_new_pet': _petCards.any((c) => !c.isExisting),
        },
      );

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
          id: card.isExisting ? card.id : _uuid.v4(),
          userId: userId,
          name: card.nameController.text.trim(),
          species: card.selectedSpecies,
          birthDate: card.selectedBirthDate,
          birthDatePrecision: card.isAgeUnknown ? 'UNKNOWN' : 'EXACT',
          image2dUrl: imageUrl,
          createdAt: card.isExisting ? null : DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (card.isExisting) {
          await ref.read(petUseCaseProvider).updatePet(pet);
        } else {
          await ref.read(petUseCaseProvider).addPet(pet);
        }
      }

      //최종 등록 성공 로그
      FirebaseAnalytics.instance.logEvent(
        name: 'pet_registration_success',
        parameters: {'final_pet_count': _petCards.length},
      );

      ref.read(showModalProvider.notifier).state = false;

      if (mounted) {
        setState(() => _isLoading = false);

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const RegistrationCompleteDialog(),
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      //에러 발생 로그
      FirebaseAnalytics.instance.logEvent(
        name: 'pet_registration_error',
        parameters: {'error_message': e.toString()},
      );
      print('Pet save error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('등록 중 오류가 발생했습니다: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              _Header(onClose: () => Navigator.of(context).pop()),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ..._petCards.asMap().entries.map((entry) {
                          final index = entry.key;
                          final cardData = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _PetFormCard(
                              cardId: '${index + 1}',
                              selectedSpecies: cardData.selectedSpecies,
                              onSpeciesChanged: (species) {
                                setState(() {
                                  cardData.selectedSpecies = species;
                                });
                              },
                              nameController: cardData.nameController,
                              ageController: cardData.ageController,
                              selectedBirthDate: cardData.selectedBirthDate,
                              isAgeUnknown: cardData.isAgeUnknown,
                              onBirthDateTap: () => _selectBirthDate(cardData),
                              selectedImage: cardData.selectedImage,
                              existingImageUrl: cardData.existingImageUrl,
                              onImageTap: () => _pickImage(cardData),
                              onImageRemove: () {
                                setState(() {
                                  cardData.selectedImage = null;
                                  cardData.existingImageUrl = null;
                                });
                              },
                              showRemoveButton: _petCards.length > 1,
                              onRemove: () => _removePetCard(cardData.id),
                            ),
                          );
                        }),
                        _AddButton(onPressed: _addPetCard),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: _CompleteButton(
                  isLoading: _isLoading,
                  onPressed: _savePet,
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

  const _Header({required this.onClose});

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
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const Text(
              '내 동물 등록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1B1F),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PetEditView()),
                );
              },
              child: const Text(
                '편집',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1C1B1F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------- Card -------------------- */
class _PetFormCard extends StatelessWidget {
  final String cardId;
  final String selectedSpecies;
  final Function(String) onSpeciesChanged;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final DateTime? selectedBirthDate;
  final bool isAgeUnknown;
  final VoidCallback onBirthDateTap;
  final XFile? selectedImage;
  final String? existingImageUrl;
  final VoidCallback onImageTap;
  final VoidCallback onImageRemove;
  final bool showRemoveButton;
  final VoidCallback? onRemove;

  const _PetFormCard({
    required this.cardId,
    required this.selectedSpecies,
    required this.onSpeciesChanged,
    required this.nameController,
    required this.ageController,
    required this.selectedBirthDate,
    required this.isAgeUnknown,
    required this.onBirthDateTap,
    required this.selectedImage,
    this.existingImageUrl,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '댕냥 $cardId',
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
                ),
            ],
          ),
          const SizedBox(height: 16),

          // 강아지 / 고양이 선택
          Row(
            children: [
              _PetType(
                isSelected: selectedSpecies == 'DOG',
                label: '강아지',
                onTap: () => onSpeciesChanged('DOG'),
              ),
              const SizedBox(width: 20),
              _PetType(
                isSelected: selectedSpecies == 'CAT',
                label: '고양이',
                onTap: () => onSpeciesChanged('CAT'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _InputField(label: '반려동물 이름', controller: nameController),
          const SizedBox(height: 24),
          _InputField(
            label: '반려동물 나이',
            controller: ageController,
            trailing: Icons.keyboard_arrow_down,
            onTap: onBirthDateTap,
          ),

          const SizedBox(height: 24),

          Row(
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
              if (selectedImage != null || existingImageUrl != null)
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
                              image: selectedImage != null
                                  ? FileImage(File(selectedImage!.path))
                                        as ImageProvider
                                  : NetworkImage(existingImageUrl!)
                                        as ImageProvider,
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {},
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -12,
                        right: 2,
                        child: GestureDetector(
                          onTap: onImageRemove,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black,
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
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
          ),
        ],
      ),
    );
  }
}

/* -------------------- Components -------------------- */

class _PetType extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const _PetType({
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

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
          onTap: () {
            FocusScope.of(context).unfocus();
            onTap?.call();
          },
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
                          onTap: label == '반려동물 나이'
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  onTap?.call();
                                }
                              : null,
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

class RegistrationCompleteDialog extends StatelessWidget {
  const RegistrationCompleteDialog({super.key});

  static const Color semanticBackgroundWhite = Color(0xFFFFFFFF);
  static const Color semanticTextBlack = Color(0xFF121416);
  static const Color semanticLineNormal = Color(0x26000000);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 335,
        decoration: BoxDecoration(
          color: semanticBackgroundWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
              child: Text(
                '내 동물 등록이 완료되었습니다.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: semanticTextBlack,
                  height: 1.35,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: semanticTextBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
