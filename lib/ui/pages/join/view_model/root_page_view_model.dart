import 'package:amumal/core/config/root_dependency.dart';
import 'package:amumal/core/utils/device_id.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_page_view_model.g.dart';

@riverpod
class RootPageViewModel extends _$RootPageViewModel {
  @override
  Future<(bool, UserModel?)> build() async {
    // 초기 로딩 시 자동 실행 로직
    return _loadData();
  }

  Future<(bool, UserModel?)> _loadData() async {
    print("=== RootPageViewModel _loadData 시작 ===");

    final deviceId = await getDeviceId();
    print("deviceId: $deviceId");

    final useCase = ref.read(rootUseCaseProvider);
    final result = await useCase.execute(deviceId);

    print("hasProfile: ${result.$1}");
    print("userData: ${result.$2}");
    print("=== RootPageViewModel _loadData 종료 ===");

    return result;
  }
}
