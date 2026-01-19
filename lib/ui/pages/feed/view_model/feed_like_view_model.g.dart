// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_like_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedLikeViewModelHash() => r'2cff065acb6933cc3ab2c3a1868f76b87a7df220';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$FeedLikeViewModel
    extends BuildlessAutoDisposeAsyncNotifier<FeedLikeState> {
  late final String feedId;

  FutureOr<FeedLikeState> build(String feedId);
}

/// See also [FeedLikeViewModel].
@ProviderFor(FeedLikeViewModel)
const feedLikeViewModelProvider = FeedLikeViewModelFamily();

/// See also [FeedLikeViewModel].
class FeedLikeViewModelFamily extends Family<AsyncValue<FeedLikeState>> {
  /// See also [FeedLikeViewModel].
  const FeedLikeViewModelFamily();

  /// See also [FeedLikeViewModel].
  FeedLikeViewModelProvider call(String feedId) {
    return FeedLikeViewModelProvider(feedId);
  }

  @override
  FeedLikeViewModelProvider getProviderOverride(
    covariant FeedLikeViewModelProvider provider,
  ) {
    return call(provider.feedId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'feedLikeViewModelProvider';
}

/// See also [FeedLikeViewModel].
class FeedLikeViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<FeedLikeViewModel, FeedLikeState> {
  /// See also [FeedLikeViewModel].
  FeedLikeViewModelProvider(String feedId)
    : this._internal(
        () => FeedLikeViewModel()..feedId = feedId,
        from: feedLikeViewModelProvider,
        name: r'feedLikeViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$feedLikeViewModelHash,
        dependencies: FeedLikeViewModelFamily._dependencies,
        allTransitiveDependencies:
            FeedLikeViewModelFamily._allTransitiveDependencies,
        feedId: feedId,
      );

  FeedLikeViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.feedId,
  }) : super.internal();

  final String feedId;

  @override
  FutureOr<FeedLikeState> runNotifierBuild(
    covariant FeedLikeViewModel notifier,
  ) {
    return notifier.build(feedId);
  }

  @override
  Override overrideWith(FeedLikeViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeedLikeViewModelProvider._internal(
        () => create()..feedId = feedId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        feedId: feedId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FeedLikeViewModel, FeedLikeState>
  createElement() {
    return _FeedLikeViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedLikeViewModelProvider && other.feedId == feedId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, feedId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeedLikeViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<FeedLikeState> {
  /// The parameter `feedId` of this provider.
  String get feedId;
}

class _FeedLikeViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          FeedLikeViewModel,
          FeedLikeState
        >
    with FeedLikeViewModelRef {
  _FeedLikeViewModelProviderElement(super.provider);

  @override
  String get feedId => (origin as FeedLikeViewModelProvider).feedId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
