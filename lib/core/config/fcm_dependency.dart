import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/fcm_repository_impl.dart';
import 'package:catdog/domain/repository/fcm_repository.dart';
import 'package:catdog/domain/use_case/fcm_use_case.dart';
import 'package:catdog/ui/pages/friend/state/fcm_event.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_dependency.g.dart';

@riverpod
FcmRepository fcmRepository(FcmRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return FcmRepositoryImpl(client);
}

@Riverpod(keepAlive: true)
Stream<FcmEvent> fcmEventStream(FcmEventStreamRef ref) {
  return FirebaseMessaging.onMessage.map((message) {
    final data = message.data;

    if (data['action'] == 'INSERT') {
      return FcmEvent(type: FcmEventType.friendRequest, who: data['who'] ?? '');
    }

    return FcmEvent(type: FcmEventType.friendAccepted, who: data['who'] ?? '');
  });
}

@riverpod
FcmUseCase fcmUseCase(FcmUseCaseRef ref) {
  return FcmUseCase(ref.read(fcmRepositoryProvider));
}

@Riverpod(keepAlive: true)
void fcmBootstrap(FcmBootstrapRef ref) {
  ref.read(fcmUseCaseProvider).execute();
}
