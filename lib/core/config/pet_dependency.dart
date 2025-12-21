import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/pet_repository_impl.dart';
import 'package:catdog/domain/repository/pet_repository.dart';
import 'package:catdog/domain/use_case/pet_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_dependency.g.dart';

@riverpod
PetRepository petRepository(PetRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return PetRepositoryImpl(client);
}

@riverpod
PetUseCase petUseCase(PetUseCaseRef ref) {
  final repository = ref.watch(petRepositoryProvider);
  return PetUseCase(repository);
}
