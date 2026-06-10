// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waitlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$waitlistRepositoryHash() =>
    r'4f0a6b2138d28fb78ad791e75053a3780533f2f1';

/// See also [waitlistRepository].
@ProviderFor(waitlistRepository)
final waitlistRepositoryProvider =
    AutoDisposeProvider<WaitlistRepository>.internal(
  waitlistRepository,
  name: r'waitlistRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waitlistRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WaitlistRepositoryRef = AutoDisposeProviderRef<WaitlistRepository>;
String _$fetchUserWaitlistHash() => r'995ef8badcaea4f8174b73436dcffe3e620b4d89';

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

/// See also [fetchUserWaitlist].
@ProviderFor(fetchUserWaitlist)
const fetchUserWaitlistProvider = FetchUserWaitlistFamily();

/// See also [fetchUserWaitlist].
class FetchUserWaitlistFamily extends Family<AsyncValue<List<Waitlist>>> {
  /// See also [fetchUserWaitlist].
  const FetchUserWaitlistFamily();

  /// See also [fetchUserWaitlist].
  FetchUserWaitlistProvider call(
    String userId,
  ) {
    return FetchUserWaitlistProvider(
      userId,
    );
  }

  @override
  FetchUserWaitlistProvider getProviderOverride(
    covariant FetchUserWaitlistProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchUserWaitlistProvider';
}

/// See also [fetchUserWaitlist].
class FetchUserWaitlistProvider
    extends AutoDisposeFutureProvider<List<Waitlist>> {
  /// See also [fetchUserWaitlist].
  FetchUserWaitlistProvider(
    String userId,
  ) : this._internal(
          (ref) => fetchUserWaitlist(
            ref as FetchUserWaitlistRef,
            userId,
          ),
          from: fetchUserWaitlistProvider,
          name: r'fetchUserWaitlistProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserWaitlistHash,
          dependencies: FetchUserWaitlistFamily._dependencies,
          allTransitiveDependencies:
              FetchUserWaitlistFamily._allTransitiveDependencies,
          userId: userId,
        );

  FetchUserWaitlistProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<Waitlist>> Function(FetchUserWaitlistRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserWaitlistProvider._internal(
        (ref) => create(ref as FetchUserWaitlistRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Waitlist>> createElement() {
    return _FetchUserWaitlistProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserWaitlistProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUserWaitlistRef on AutoDisposeFutureProviderRef<List<Waitlist>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _FetchUserWaitlistProviderElement
    extends AutoDisposeFutureProviderElement<List<Waitlist>>
    with FetchUserWaitlistRef {
  _FetchUserWaitlistProviderElement(super.provider);

  @override
  String get userId => (origin as FetchUserWaitlistProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
