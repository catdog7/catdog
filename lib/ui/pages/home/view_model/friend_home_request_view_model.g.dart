// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_home_request_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$friendHomeRequestViewModelHash() =>
    r'728a4031e4ee19b5fbcb49afc11d29825d14f4de';

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

abstract class _$FriendHomeRequestViewModel
    extends BuildlessAutoDisposeAsyncNotifier<FriendHomeRequestState> {
  late final String friendId;

  FutureOr<FriendHomeRequestState> build(String friendId);
}

/// See also [FriendHomeRequestViewModel].
@ProviderFor(FriendHomeRequestViewModel)
const friendHomeRequestViewModelProvider = FriendHomeRequestViewModelFamily();

/// See also [FriendHomeRequestViewModel].
class FriendHomeRequestViewModelFamily
    extends Family<AsyncValue<FriendHomeRequestState>> {
  /// See also [FriendHomeRequestViewModel].
  const FriendHomeRequestViewModelFamily();

  /// See also [FriendHomeRequestViewModel].
  FriendHomeRequestViewModelProvider call(String friendId) {
    return FriendHomeRequestViewModelProvider(friendId);
  }

  @override
  FriendHomeRequestViewModelProvider getProviderOverride(
    covariant FriendHomeRequestViewModelProvider provider,
  ) {
    return call(provider.friendId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'friendHomeRequestViewModelProvider';
}

/// See also [FriendHomeRequestViewModel].
class FriendHomeRequestViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          FriendHomeRequestViewModel,
          FriendHomeRequestState
        > {
  /// See also [FriendHomeRequestViewModel].
  FriendHomeRequestViewModelProvider(String friendId)
    : this._internal(
        () => FriendHomeRequestViewModel()..friendId = friendId,
        from: friendHomeRequestViewModelProvider,
        name: r'friendHomeRequestViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$friendHomeRequestViewModelHash,
        dependencies: FriendHomeRequestViewModelFamily._dependencies,
        allTransitiveDependencies:
            FriendHomeRequestViewModelFamily._allTransitiveDependencies,
        friendId: friendId,
      );

  FriendHomeRequestViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.friendId,
  }) : super.internal();

  final String friendId;

  @override
  FutureOr<FriendHomeRequestState> runNotifierBuild(
    covariant FriendHomeRequestViewModel notifier,
  ) {
    return notifier.build(friendId);
  }

  @override
  Override overrideWith(FriendHomeRequestViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: FriendHomeRequestViewModelProvider._internal(
        () => create()..friendId = friendId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        friendId: friendId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    FriendHomeRequestViewModel,
    FriendHomeRequestState
  >
  createElement() {
    return _FriendHomeRequestViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FriendHomeRequestViewModelProvider &&
        other.friendId == friendId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, friendId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FriendHomeRequestViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<FriendHomeRequestState> {
  /// The parameter `friendId` of this provider.
  String get friendId;
}

class _FriendHomeRequestViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          FriendHomeRequestViewModel,
          FriendHomeRequestState
        >
    with FriendHomeRequestViewModelRef {
  _FriendHomeRequestViewModelProviderElement(super.provider);

  @override
  String get friendId =>
      (origin as FriendHomeRequestViewModelProvider).friendId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
