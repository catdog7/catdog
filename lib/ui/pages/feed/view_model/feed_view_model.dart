import 'package:catdog/domain/use_case/upload_feed_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'feed_view_model.g.dart';


@riverpod
class FeedViewModel extends _$FeedViewModel{

  @override
  XFile? build(){
    return null; // 초기 값 설정
  }
  //이미지 피커 사용하는 메서드
  Future<void> pickImage() async{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      state = image;
    }
  }

  // feed_view_model.dart 내부에 추가
Future<void> uploadPost(String content) async {
  final image = state; // 현재 선택된 XFile 상태
  if (image == null || content.isEmpty) return; // 간단한 방어 코드

  try {
    // 1. 이미지 파일명 생성 (중복 방지용 UUID 등)
    // final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    // final bytes = await image.readAsBytes(); // 파일을 바이트로 변환


    // // 2. Supabase Storage에 이미지 업로드
    // final supabase = Supabase.instance.client;
    // //정보를 가져옴
    // final user = supabase.auth.currentUser;
    
    // if(user == null){
    //   print("로그린 해주세요");
    //   return;
    // }
    
    // await supabase.storage.from('feed_image').uploadBinary(fileName, bytes);

    // // 3. 이미지 URL 가져오기
    // final imageUrl = supabase.storage.from('feed_image').getPublicUrl(fileName);

    // // 4. Database(Table)에 게시글 정보 저장
    // await supabase.from('feeds').insert({
    //   'content': content,
    //   'image_url': imageUrl,
    //   'user_id': user.id,
    //   'created_at': DateTime.now().toIso8601String(),
    // });

    // use case를 만들어줬으니 use case를 불러오면됨 데이터를 직접불러오는게 아니라
    final uploadFeedUseCase = ref.read(uploadFeedUseCaseProvider);
    await uploadFeedUseCase.execute(image!, content);

    // 5. 업로드 성공 후 상태 초기화
    state = null; 
  } catch (e) {
    print("업로드 에러: $e");
  }
}
}
