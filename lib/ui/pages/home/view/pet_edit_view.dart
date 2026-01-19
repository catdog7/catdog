import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/core/config/pet_dependency.dart';
import 'package:catdog/domain/model/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetEditView extends ConsumerStatefulWidget {
  const PetEditView({super.key});

  @override
  ConsumerState<PetEditView> createState() => _PetEditViewState();
}

class _PetEditViewState extends ConsumerState<PetEditView> {
  List<PetModel> _pets = [];
  Set<String> _selectedPetIds = {};
  bool _isLoading = true;

  static const Color semanticBackgroundLight = Color(0xFFF8FAFE);
  static const Color semanticBackgroundWhite = Color(0xFFFFFFFF);
  static const Color semanticTextBlack = Color(0xFF121416);
  static const Color semanticLineLight = Color(0x0D000000);
  static const Color semanticTextWeak = Color(0x4D000000);
  static const Color semanticPrimaryNormal = Color(0xFFFDCA40);

  @override
  void initState() {
    super.initState();
    _loadPets();
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
        _pets = pets;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('_loadPets error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _toggleSelection(String petId) {
    setState(() {
      if (_selectedPetIds.contains(petId)) {
        _selectedPetIds.remove(petId);
      } else {
        _selectedPetIds.add(petId);
      }
    });
  }

  Future<void> _deleteSelectedPets() async {
    if (_selectedPetIds.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        petCount: _selectedPetIds.length,
      ),
    );

    if (confirmed == true) {
      try {
        final petUseCase = ref.read(petUseCaseProvider);
        for (final petId in _selectedPetIds) {
          await petUseCase.removePet(petId);
        }
        
        if (mounted) {
          await _loadPets();
          setState(() {
            _selectedPetIds.clear();
          });
        }
      } catch (e) {
        debugPrint('Delete error: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제 중 오류가 발생했습니다.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: semanticBackgroundWhite,
      appBar: AppBar(
        backgroundColor: semanticBackgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: semanticTextBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '내 동물 편집',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: semanticTextBlack,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _selectedPetIds.isEmpty ? null : _deleteSelectedPets,
            child: Text(
              '삭제',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _selectedPetIds.isEmpty
                    ? semanticTextBlack.withOpacity(0.3)
                    : semanticTextBlack,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _pets.isEmpty
                ? const Center(
                    child: Text(
                      '등록된 동물이 없습니다.',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        color: semanticTextWeak,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      ..._pets.map((pet) => _buildPetItem(pet)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildPetItem(PetModel pet) {
    final isSelected = _selectedPetIds.contains(pet.id);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _toggleSelection(pet.id),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: 68,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: semanticBackgroundWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: semanticLineLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEEEEEE),
                    ),
                    child: ClipOval(
                      child: pet.image2dUrl != null && pet.image2dUrl!.isNotEmpty
                          ? Image.network(
                              pet.image2dUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.pets, size: 16),
                            )
                          : const Icon(Icons.pets, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? semanticPrimaryNormal : semanticTextWeak,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final int petCount;

  const DeleteConfirmationDialog({
    super.key,
    required this.petCount,
  });

  static const Color semanticBackgroundWhite = Color(0xFFFFFFFF);
  static const Color semanticTextBlack = Color(0xFF121416);
  static const Color semanticStatusNormal = Color(0xFFFE3752);
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
            // 타이틀 영역
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 20, right: 20),
              child: Text(
                '선택한 동물을 삭제하시겠어요?',
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
              child: Row(
                children: [
                  Expanded(
                    child: _buildModalButton(
                      label: '취소',
                      onPressed: () => Navigator.pop(context, false),
                      backgroundColor: const Color(0xFFF1F3F5),
                      textColor: semanticTextBlack,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildModalButton(
                      label: '삭제',
                      onPressed: () => Navigator.pop(context, true),
                      backgroundColor: semanticTextBlack,
                      textColor: Colors.white,
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

  Widget _buildModalButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

