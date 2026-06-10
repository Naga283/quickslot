// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingsRepositoryHash() =>
    r'6917dfa4257c11b7d1e1297bc24d814f8af6f968';

/// See also [bookingsRepository].
@ProviderFor(bookingsRepository)
final bookingsRepositoryProvider =
    AutoDisposeProvider<BookingsRepository>.internal(
  bookingsRepository,
  name: r'bookingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookingsRepositoryRef = AutoDisposeProviderRef<BookingsRepository>;
String _$fetchUserBookingsHash() => r'5cba23c749869f7c2b4bc5e534c1a2895abfa461';

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

/// See also [fetchUserBookings].
@ProviderFor(fetchUserBookings)
const fetchUserBookingsProvider = FetchUserBookingsFamily();

/// See also [fetchUserBookings].
class FetchUserBookingsFamily extends Family<AsyncValue<List<Booking>>> {
  /// See also [fetchUserBookings].
  const FetchUserBookingsFamily();

  /// See also [fetchUserBookings].
  FetchUserBookingsProvider call(
    String userId,
  ) {
    return FetchUserBookingsProvider(
      userId,
    );
  }

  @override
  FetchUserBookingsProvider getProviderOverride(
    covariant FetchUserBookingsProvider provider,
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
  String? get name => r'fetchUserBookingsProvider';
}

/// See also [fetchUserBookings].
class FetchUserBookingsProvider
    extends AutoDisposeFutureProvider<List<Booking>> {
  /// See also [fetchUserBookings].
  FetchUserBookingsProvider(
    String userId,
  ) : this._internal(
          (ref) => fetchUserBookings(
            ref as FetchUserBookingsRef,
            userId,
          ),
          from: fetchUserBookingsProvider,
          name: r'fetchUserBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserBookingsHash,
          dependencies: FetchUserBookingsFamily._dependencies,
          allTransitiveDependencies:
              FetchUserBookingsFamily._allTransitiveDependencies,
          userId: userId,
        );

  FetchUserBookingsProvider._internal(
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
    FutureOr<List<Booking>> Function(FetchUserBookingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserBookingsProvider._internal(
        (ref) => create(ref as FetchUserBookingsRef),
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
  AutoDisposeFutureProviderElement<List<Booking>> createElement() {
    return _FetchUserBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserBookingsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUserBookingsRef on AutoDisposeFutureProviderRef<List<Booking>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _FetchUserBookingsProviderElement
    extends AutoDisposeFutureProviderElement<List<Booking>>
    with FetchUserBookingsRef {
  _FetchUserBookingsProviderElement(super.provider);

  @override
  String get userId => (origin as FetchUserBookingsProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
