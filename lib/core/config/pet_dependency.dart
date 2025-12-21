import 'package:catdog/core/config/common_dependency.dart';
import 'package:catdog/data/repository_impl/pet_repository_impl.dart';
import 'package:catdog/domain/repository/pet_repository.dart';
import 'package:catdog/domain/use_case/pet_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pet_dependency.g.dart';

@riverpod
PetRepository petRepository(PetRepositoryRef ref) => 
    PetRepositoryImpl(client: ref.read(supabaseClientProvider));

@riverpod
PetUseCase petUseCase(PetUseCaseRef ref) => 
    PetUseCase(ref.read(petRepositoryProvider));
