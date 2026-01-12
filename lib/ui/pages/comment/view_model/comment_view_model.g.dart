// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentViewModelHash() => r'6f10d50edf25bc70960e976bde63619c3671064c';

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

abstract class _$CommentViewModel
    extends BuildlessAutoDisposeAsyncNotifier<CommentState> {
  late final String feedId;

  FutureOr<CommentState> build(String feedId);
}

/// See also [CommentViewModel].
@ProviderFor(CommentViewModel)
const commentViewModelProvider = CommentViewModelFamily();

/// See also [CommentViewModel].
class CommentViewModelFamily extends Family<AsyncValue<CommentState>> {
  /// See also [CommentViewModel].
  const CommentViewModelFamily();

  /// See also [CommentViewModel].
  CommentViewModelProvider call(String feedId) {
    return CommentViewModelProvider(feedId);
  }

  @override
  CommentViewModelProvider getProviderOverride(
    covariant CommentViewModelProvider provider,
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
  String? get name => r'commentViewModelProvider';
}

/// See also [CommentViewModel].
class CommentViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<CommentViewModel, CommentState> {
  /// See also [CommentViewModel].
  CommentViewModelProvider(String feedId)
    : this._internal(
        () => CommentViewModel()..feedId = feedId,
        from: commentViewModelProvider,
        name: r'commentViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$commentViewModelHash,
        dependencies: CommentViewModelFamily._dependencies,
        allTransitiveDependencies:
            CommentViewModelFamily._allTransitiveDependencies,
        feedId: feedId,
      );

  CommentViewModelProvider._internal(
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
  FutureOr<CommentState> runNotifierBuild(covariant CommentViewModel notifier) {
    return notifier.build(feedId);
  }

  @override
  Override overrideWith(CommentViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommentViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<CommentViewModel, CommentState>
  createElement() {
    return _CommentViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentViewModelProvider && other.feedId == feedId;
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
mixin CommentViewModelRef on AutoDisposeAsyncNotifierProviderRef<CommentState> {
  /// The parameter `feedId` of this provider.
  String get feedId;
}

class _CommentViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<CommentViewModel, CommentState>
    with CommentViewModelRef {
  _CommentViewModelProviderElement(super.provider);

  @override
  String get feedId => (origin as CommentViewModelProvider).feedId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
