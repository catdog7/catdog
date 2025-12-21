// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentViewModelHash() => r'c3ea185167005cba47da9ef3a6bb52a9207237d4';

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
  late final UserModel user;

  FutureOr<CommentState> build({
    required String feedId,
    required UserModel user,
  });
}

/// See also [CommentViewModel].
@ProviderFor(CommentViewModel)
const commentViewModelProvider = CommentViewModelFamily();

/// See also [CommentViewModel].
class CommentViewModelFamily extends Family<AsyncValue<CommentState>> {
  /// See also [CommentViewModel].
  const CommentViewModelFamily();

  /// See also [CommentViewModel].
  CommentViewModelProvider call({
    required String feedId,
    required UserModel user,
  }) {
    return CommentViewModelProvider(feedId: feedId, user: user);
  }

  @override
  CommentViewModelProvider getProviderOverride(
    covariant CommentViewModelProvider provider,
  ) {
    return call(feedId: provider.feedId, user: provider.user);
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
  CommentViewModelProvider({required String feedId, required UserModel user})
    : this._internal(
        () => CommentViewModel()
          ..feedId = feedId
          ..user = user,
        from: commentViewModelProvider,
        name: r'commentViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$commentViewModelHash,
        dependencies: CommentViewModelFamily._dependencies,
        allTransitiveDependencies:
            CommentViewModelFamily._allTransitiveDependencies,
        feedId: feedId,
        user: user,
      );

  CommentViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.feedId,
    required this.user,
  }) : super.internal();

  final String feedId;
  final UserModel user;

  @override
  FutureOr<CommentState> runNotifierBuild(covariant CommentViewModel notifier) {
    return notifier.build(feedId: feedId, user: user);
  }

  @override
  Override overrideWith(CommentViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommentViewModelProvider._internal(
        () => create()
          ..feedId = feedId
          ..user = user,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        feedId: feedId,
        user: user,
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
    return other is CommentViewModelProvider &&
        other.feedId == feedId &&
        other.user == user;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, feedId.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommentViewModelRef on AutoDisposeAsyncNotifierProviderRef<CommentState> {
  /// The parameter `feedId` of this provider.
  String get feedId;

  /// The parameter `user` of this provider.
  UserModel get user;
}

class _CommentViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<CommentViewModel, CommentState>
    with CommentViewModelRef {
  _CommentViewModelProviderElement(super.provider);

  @override
  String get feedId => (origin as CommentViewModelProvider).feedId;
  @override
  UserModel get user => (origin as CommentViewModelProvider).user;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
