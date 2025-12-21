import 'dart:io';

import 'package:amumal/core/config/feed_dependency.dart';
import 'package:amumal/domain/model/feed_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:amumal/core/utils/debouncer.dart';
part 'feed_view_model.g.dart';

/// Feed 작성 화면의 UI 상태를 관리하는 ViewModel
/// UI 관련 로직만 담당하고, 비즈니스 로직은 UseCase에 위임
@riverpod
class FeedViewModel extends _$FeedViewModel {
  @override
  File? build() {
    // Provider가 dispose될 때 Debouncer 정리
    ref.onDispose(() {
      _autoSaveDebouncer?.dispose();
    });
    
    return null; // 초기값: 선택된 이미지 파일 없음
  }

  // === 내부 상태 변수 (UI 입력 값) ===
  String _tag = "";
  String _content = "";
  final ImagePicker _picker = ImagePicker();

  // === 자동 저장을 위한 Debouncer ===
  Debouncer? _autoSaveDebouncer;

  // === 수정 모드 관련 변수 ===
  String? _editModeFeedId;
  String? _writerId;
  String? _nickname;
  DateTime? _existingCreatedAt;
  String? _existingImageUrl; // 기존 이미지 URL (이미지 변경하지 않았을 때 사용)

    /// 자동 저장 Debouncer 초기화 (수정 모드에서만 사용)
  void _initializeAutoSave() {
    if (_autoSaveDebouncer != null) return; // 이미 초기화되었으면 리턴
    
    _autoSaveDebouncer = Debouncer(
      duration: const Duration(seconds: 3), // 3초 후 자동 저장
      callback: () {
        _performAutoSave();
      },
    );
  }

  /// 실제 자동 저장 실행
  Future<void> _performAutoSave() async {
    if (_editModeFeedId == null) {
      return; // 수정 모드가 아니면 종료
    }
    
    if (_content.trim().isEmpty) {
      return;
    }

    try {
      final feedUseCase = ref.read(feedUseCaseProvider);
      
      // 이미지가 변경되었는지 확인
      if (state != null && await state!.exists()) {
        // 새 이미지가 선택된 경우
        await feedUseCase.modifyFeed(
          id: _editModeFeedId!,
          writerId: _writerId ?? '',
          nickname: _nickname ?? '',
          tagString: _tag,
          content: _content,
          imageFile: state!,
          existingCreatedAt: _existingCreatedAt ?? DateTime.now(),
        );
      } else if (_existingImageUrl != null) {
        // 이미지를 변경하지 않았을 경우 기존 이미지 URL 사용
        await feedUseCase.modifyFeedWithoutImage(
          id: _editModeFeedId!,
          writerId: _writerId ?? '',
          nickname: _nickname ?? '',
          tagString: _tag,
          content: _content,
          existingImageUrl: _existingImageUrl!,
          existingCreatedAt: _existingCreatedAt ?? DateTime.now(),
        );
      } else {
        return;
      }
    } catch (e) {
      print('자동 저장 실패: $e');
    }
  }

  /// 이미지 선택 (UI 이벤트 처리)
  Future<void> pickImage(ImageSource imageSource) async {
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      state = File(pickedFile.path); // State 업데이트 (UI 자동 rebuild)
      
      // 수정 모드일 때 이미지 변경 시 자동 저장 트리거
      if (_editModeFeedId != null) {
        _autoSaveDebouncer?.run();
      }
    }
  }

  /// 태그 입력 값 업데이트 (UI 이벤트 처리)
  void updateTag(String tag) {
    _tag = tag;
    
    // 수정 모드일 때 자동 저장 트리거
    if (_editModeFeedId != null) {
      _autoSaveDebouncer?.run();
    }
  }

  /// 내용 입력 값 업데이트 (UI 이벤트 처리)
  void updateContent(String content) {
    _content = content;
    
    // 수정 모드일 때 자동 저장 트리거
    if (_editModeFeedId != null) {
      _autoSaveDebouncer?.run();
    }
  }

  /// 피드 등록 (UseCase 호출)
  /// 비즈니스 로직은 UseCase에서 처리
  /// 반환값: 성공 시 null, 실패 시 에러 메시지
  Future<String?> createFeed({
    required String writerId,
    required String nickname,
  }) async {
    // UI 레벨 유효성 검사: 이미지 체크
    if (state == null) {
      return '이미지를 선택해주세요.';
    }
    
    // 파일 존재 여부 확인
    if (!await state!.exists()) {
      return '이미지 파일이 존재하지 않습니다.';
    }
    
    // 콘텐츠 검증 (빈 문자열이거나 공백만 있는 경우)
    final trimmedContent = _content.trim();
    if (trimmedContent.isEmpty) {
      return '피드 내용을 입력해주세요.';
    }

    try {
      // UseCase 호출 (앱 정책 처리: 이미지 업로드, createdAt/modifiedAt 설정 등)
      final feedUseCase = ref.read(feedUseCaseProvider);
      await feedUseCase.createFeed(
        writerId: writerId,
        nickname: nickname,
        tagString: _tag,
        content: _content,
        imageFile: state!,
      );

      // 성공 시 상태 초기화 및 자동 저장 취소
      state = null;
      _tag = '';
      _content = '';
      cancelAutoSave(); // 자동 저장 취소
      _editModeFeedId = null;
      _writerId = null;
      _nickname = null;
      _existingCreatedAt = null;
      _existingImageUrl = null;

      return null; // 성공
    } catch (e) {
      // 에러 메시지 추출
      String errorMessage = '피드 등록에 실패했습니다.';
      
      if (e is ArgumentError) {
        // ArgumentError의 메시지 사용
        errorMessage = e.message ?? errorMessage;
      } else {
        // 기타 에러는 원본 메시지 사용
        errorMessage = e.toString();
      }
      
      print("피드 등록 오류: $e");
      return errorMessage; // 에러 메시지 반환
    }
  }

  /// 피드 수정 (UseCase 호출)
  /// 비즈니스 로직은 UseCase에서 처리
  /// 반환값: 성공 시 null, 실패 시 에러 메시지
  Future<String?> modifyFeed({
    required String feedId,
    required String writerId,
    required String nickname,
    required DateTime existingCreatedAt,
  }) async {
    // 콘텐츠 검증 (빈 문자열이거나 공백만 있는 경우)
    final trimmedContent = _content.trim();
    if (trimmedContent.isEmpty) {
      return '피드 내용을 입력해주세요.';
    }

    try {
      // UseCase 호출 (앱 정책 처리: 이미지 업로드, modifiedAt 설정 등)
      final feedUseCase = ref.read(feedUseCaseProvider);
      
      // 이미지가 변경되었는지 확인
      if (state != null && await state!.exists()) {
        // 새 이미지가 선택된 경우
        await feedUseCase.modifyFeed(
          id: feedId,
          writerId: writerId,
          nickname: nickname,
          tagString: _tag,
          content: _content,
          imageFile: state!,
          existingCreatedAt: existingCreatedAt,
        );
      } else if (_existingImageUrl != null) {
        // 이미지를 변경하지 않았을 경우 기존 이미지 URL 사용
        await feedUseCase.modifyFeedWithoutImage(
          id: feedId,
          writerId: writerId,
          nickname: nickname,
          tagString: _tag,
          content: _content,
          existingImageUrl: _existingImageUrl!,
          existingCreatedAt: existingCreatedAt,
        );
      } else {
        return '이미지를 선택해주세요.';
      }

      // 성공 시 상태 초기화 및 자동 저장 취소
      state = null;
      _tag = '';
      _content = '';
      cancelAutoSave(); // 자동 저장 취소
      _editModeFeedId = null;
      _writerId = null;
      _nickname = null;
      _existingCreatedAt = null;
      _existingImageUrl = null;

      return null; // 성공
    } catch (e) {
      // 에러 메시지 추출
      String errorMessage = '피드 수정에 실패했습니다.';
      
      if (e is ArgumentError) {
        // ArgumentError의 메시지 사용
        errorMessage = e.message ?? errorMessage;
      } else {
        // 기타 에러는 원본 메시지 사용
        errorMessage = e.toString();
      }
      
      print("피드 수정 오류: $e");
      return errorMessage; // 에러 메시지 반환
    }
  }

  /// 기존 피드 데이터로 ViewModel 초기화 (수정 모드용)
  void initializeWithExistingFeed(
    FeedModel feed, {
    required String writerId,
    required String nickname,
  }) {
    _tag = feed.tag.join(',');
    _content = feed.content;
    _editModeFeedId = feed.id;
    _writerId = writerId;
    _nickname = nickname;
    _existingCreatedAt = feed.createdAt;
    _existingImageUrl = feed.imageUrl; // 기존 이미지 URL 저장
    // 이미지는 URL이므로 File로 변환할 수 없음
    // 수정 모드에서는 사용자가 새 이미지를 선택해야 함
    state = null;
    
    // 자동 저장 Debouncer 초기화
    _initializeAutoSave();
  }

  /// 완료 버튼 클릭 시 자동 저장 취소 (선택적)
  void cancelAutoSave() {
    _autoSaveDebouncer?.dispose();
    _autoSaveDebouncer = null;
  }
}