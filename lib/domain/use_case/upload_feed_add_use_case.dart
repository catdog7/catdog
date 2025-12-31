import 'package:catdog/data/repository_impl/feed_add_repository_Impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';


class FeedAddUseCase {
  final FeedAddRepositoryImpl _repository;

  FeedAddUseCase(this._repository);

  // UI 에서 사진과 글을 받아서 레파지 토리로 전달
  Future<void> execute(XFile image, String content)async{
    return await _repository.uploadFeed(image, content);

  }
}

//  ViewModel에서 이 유스케이스를 불러올 수 있게 Provider를 만듭니다.
final feedAddUseCaseProvider = Provider((ref) {
  final repository = ref.watch(feedAddRepositoryProvider);
  return FeedAddUseCase(repository);
});