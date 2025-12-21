// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedViewModelHash() => r'5a08de7b337de03aca1dcb8d7b0f311e55403c7d';

/// Feed 작성 화면의 UI 상태를 관리하는 ViewModel
/// UI 관련 로직만 담당하고, 비즈니스 로직은 UseCase에 위임
///
/// Copied from [FeedViewModel].
@ProviderFor(FeedViewModel)
final feedViewModelProvider =
    AutoDisposeNotifierProvider<FeedViewModel, File?>.internal(
      FeedViewModel.new,
      name: r'feedViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FeedViewModel = AutoDisposeNotifier<File?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
