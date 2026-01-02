import 'dart:io';
import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/pet_dependency.dart';
import 'package:catdog/domain/model/pet_model.dart';
import 'package:catdog/ui/pages/home/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// 동물 카드 데이터 클래스
class _PetCardData {
  final String id;
  final TextEditingController nameController;
  final TextEditingController ageController; // 나이 입력 필드용 controller
  String selectedSpecies;
  DateTime? selectedBirthDate;
  XFile? selectedImage;
  bool isAgeUnknown;

  _PetCardData({
    required this.id,
    required this.nameController,
    required this.ageController,
    required this.selectedSpecies,
    this.selectedBirthDate,
    this.selectedImage,
    this.isAgeUnknown = false,
  });
}

class PetRegisterView extends ConsumerStatefulWidget {
  const PetRegisterView({super.key});

  @override
  ConsumerState<PetRegisterView> createState() => _PetRegisterViewState();
}

class _PetRegisterViewState extends ConsumerState<PetRegisterView> {
  final List<_PetCardData> _petCards = [
    _PetCardData(
      id: '1',
      nameController: TextEditingController(),
      ageController: TextEditingController(),
      selectedSpecies: 'DOG',
      selectedBirthDate: null,
      selectedImage: null,
      isAgeUnknown: false,
    ),
  ];
  final _uuid = const Uuid();
  bool _isLoading = false;

  @override
  void dispose() {
    for (var card in _petCards) {
      card.nameController.dispose();
      card.ageController.dispose();
    }
    super.dispose();
  }

  void _addPetCard() {
    setState(() {
      _petCards.add(_PetCardData(
        id: '${_petCards.length + 1}',
        nameController: TextEditingController(),
        ageController: TextEditingController(),
        selectedSpecies: 'DOG',
        selectedBirthDate: null,
        selectedImage: null,
        isAgeUnknown: false,
      ));
    });
  }

  void _removePetCard(String id) {
    setState(() {
      final index = _petCards.indexWhere((card) => card.id == id);
      if (index != -1) {
        _petCards[index].nameController.dispose();
        _petCards[index].ageController.dispose();
        _petCards.removeAt(index);
      }
    });
  }

  Future<void> _pickImage(_PetCardData cardData) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        cardData.selectedImage = image;
      });
    }
  }

  Future<void> _selectBirthDate(_PetCardData cardData) async {
    DateTime tempDate = cardData.selectedBirthDate ?? DateTime.now();
    bool tempIsAgeUnknown = cardData.isAgeUnknown;
    // 초기값 설정
    if (cardData.isAgeUnknown) {
      cardData.ageController.text = '모름';
    } else if (cardData.selectedBirthDate != null) {
      cardData.ageController.text = DateFormat('yyyy년 M월 d일').format(cardData.selectedBirthDate!);
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
                  // 드래그 바
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

                  // 년 / 월 / 일 타이틀
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

                  // 날짜 휠
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

                  // 나이 모름
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
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (value) {
                            setModalState(() {
                              tempIsAgeUnknown = value ?? false;
                            });
                          },
                        ),
                          const Text(
                            '나이 모름',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 버튼
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).padding.bottom + 20),
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
                              // 1️⃣ 완전히 포커스 제거 (중요)
                              FocusManager.instance.primaryFocus?.unfocus();

                              // 2️⃣ 상태 업데이트
                              setState(() {
                                if (tempIsAgeUnknown) {
                                  cardData.selectedBirthDate = null;
                                  cardData.isAgeUnknown = true;
                                  cardData.ageController.text = '모름';
                                } else {
                                  cardData.selectedBirthDate = tempDate;
                                  cardData.isAgeUnknown = false;
                                  cardData.ageController.text = DateFormat('yyyy년 M월 d일').format(tempDate);
                                }
                              });

                              // 3️⃣ 한 프레임 뒤에 모달 닫기
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
    // 모든 카드 검증
    for (var card in _petCards) {
      if (card.nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 반려동물 이름을 입력해주세요.')),
        );
        return;
      }

      if (card.selectedBirthDate == null && !card.isAgeUnknown) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 반려동물 나이를 선택해주세요.')),
        );
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

      // 모든 카드 저장
      for (var card in _petCards) {
        String? imageUrl;
        if (card.selectedImage != null) {
          try {
            // 이미지 업로드
            final fileName = "${DateTime.now().millisecondsSinceEpoch}_${card.id}.jpg";
            final bytes = await card.selectedImage!.readAsBytes();
            await client.storage.from("pet_image").uploadBinary(fileName, bytes);
            imageUrl = client.storage.from('pet_image').getPublicUrl(fileName);
          } catch (e) {
            print('Image upload error: $e');
            // 이미지 업로드 실패 시에도 계속 진행 (이미지 없이 저장)
            // 403 에러는 Supabase Storage RLS 정책 설정이 필요합니다
            imageUrl = null;
          }
        }

        // PetModel 생성
        final pet = PetModel(
          id: _uuid.v4(),
          userId: userId,
          name: card.nameController.text.trim(),
          species: card.selectedSpecies,
          birthDate: card.selectedBirthDate,
          birthDatePrecision: card.isAgeUnknown ? 'UNKNOWN' : 'EXACT',
          image2dUrl: imageUrl,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // 저장
        await ref.read(petUseCaseProvider).addPet(pet);
      }

      // 모달 상태 업데이트 (동물이 있으므로 팝업 숨김)
      ref.read(showModalProvider.notifier).state = false;

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_petCards.length}마리의 반려동물이 등록되었습니다.')),
        );
      }
    } catch (e) {
      print('Pet save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 중 오류가 발생했습니다: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // 상단 헤더
            _Header(
              onClose: () => Navigator.of(context).pop(),
            ),

            // 카드 영역
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // 동물 카드들
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
                            onImageTap: () => _pickImage(cardData),
                            onImageRemove: () {
                              setState(() {
                                cardData.selectedImage = null;
                              });
                            },
                            showRemoveButton: index != 0,
                            onRemove: () => _removePetCard(cardData.id),
                          ),
                        );
                      }),

                      // 추가하기 버튼
                      _AddButton(onPressed: _addPetCard),
                    ],
                  ),
                ),
              ),
            ),

            // 완료 버튼
            Padding(
              padding: const EdgeInsets.all(20),
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
              icon: const Icon(Icons.arrow_back, size: 24, color: Color(0xFF1C1B1F)),
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
            IconButton(
              icon: const Icon(Icons.format_list_bulleted, size: 24, color: Color(0xFF1C1B1F)),
              onPressed: () {
                // TODO: 리스트 기능 구현
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
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
          )
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

          _InputField(
            label: '반려동물 이름',
            controller: nameController,
          ),
          const SizedBox(height: 24),
          _InputField(
            label: '반려동물 나이',
            controller: ageController,
            trailing: Icons.keyboard_arrow_down,
            onTap: onBirthDateTap,
          ),

          const SizedBox(height: 24),

            // 이미지 등록
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
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
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
              if (selectedImage != null)
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
                              image: FileImage(File(selectedImage!.path)),
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
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black,
                            child: const Icon(Icons.close, size: 16, color: Colors.white),
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
                  color: isSelected ? const Color(0xFFFDCA40) : const Color(0xFFDDDFE3),
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
            // 포커스 해제 후 onTap 실행
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

  const _CompleteButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFDCA40),
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
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
