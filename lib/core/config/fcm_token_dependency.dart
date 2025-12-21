import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/fcm_token_repository_impl.dart';
import 'package:catdog/domain/repository/fcm_token_repository.dart';
import 'package:catdog/domain/use_case/fcm_token_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_token_dependency.g.dart';

@riverpod
FcmTokenRepository fcmTokenRepository(FcmTokenRepositoryRef ref) => 
    FcmTokenRepositoryImpl(client: ref.read(supabaseClientProvider));

@riverpod
FcmTokenUseCase fcmTokenUseCase(FcmTokenUseCaseRef ref) => 
    FcmTokenUseCase(ref.read(fcmTokenRepositoryProvider));
