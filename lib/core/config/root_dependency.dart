import 'package:amumal/core/config/common_dependency.dart';
import 'package:amumal/data/repository_impl/root_page_repository_impl.dart';
import 'package:amumal/domain/repository/root_page_repository.dart';
import 'package:amumal/domain/use_case/root_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_dependency.g.dart';

@riverpod
RootPageRepository rootRepository(ref) => RootPageRepositoryImpl(db: ref.read(firebaseFirestoreProvider));

@riverpod
RootUseCase rootUseCase(ref) => RootUseCase(ref.read(rootRepositoryProvider));