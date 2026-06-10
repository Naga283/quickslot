// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venues_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$venuesRepositoryHash() => r'146e63ef64c494d06997b3607e1f22ec74d01bbf';

/// See also [venuesRepository].
@ProviderFor(venuesRepository)
final venuesRepositoryProvider = AutoDisposeProvider<VenuesRepository>.internal(
  venuesRepository,
  name: r'venuesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$venuesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef VenuesRepositoryRef = AutoDisposeProviderRef<VenuesRepository>;
String _$fetchVenuesHash() => r'733a545ed27eb349fabe72efe76a8b0d421ab920';

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

/// See also [fetchVenues].
@ProviderFor(fetchVenues)
const fetchVenuesProvider = FetchVenuesFamily();

/// See also [fetchVenues].
class FetchVenuesFamily
    extends Family<AsyncValue<(List<Venue> venues, int totalCount)>> {
  /// See also [fetchVenues].
  const FetchVenuesFamily();

  /// See also [fetchVenues].
  FetchVenuesProvider call({
    String? sportType,
    int page = 1,
    int limit = 10,
  }) {
    return FetchVenuesProvider(
      sportType: sportType,
      page: page,
      limit: limit,
    );
  }

  @override
  FetchVenuesProvider getProviderOverride(
    covariant FetchVenuesProvider provider,
  ) {
    return call(
      sportType: provider.sportType,
      page: provider.page,
      limit: provider.limit,
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
  String? get name => r'fetchVenuesProvider';
}

/// See also [fetchVenues].
class FetchVenuesProvider
    extends AutoDisposeFutureProvider<(List<Venue> venues, int totalCount)> {
  /// See also [fetchVenues].
  FetchVenuesProvider({
    String? sportType,
    int page = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchVenues(
            ref as FetchVenuesRef,
            sportType: sportType,
            page: page,
            limit: limit,
          ),
          from: fetchVenuesProvider,
          name: r'fetchVenuesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchVenuesHash,
          dependencies: FetchVenuesFamily._dependencies,
          allTransitiveDependencies:
              FetchVenuesFamily._allTransitiveDependencies,
          sportType: sportType,
          page: page,
          limit: limit,
        );

  FetchVenuesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sportType,
    required this.page,
    required this.limit,
  }) : super.internal();

  final String? sportType;
  final int page;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<(List<Venue> venues, int totalCount)> Function(
            FetchVenuesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchVenuesProvider._internal(
        (ref) => create(ref as FetchVenuesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sportType: sportType,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(List<Venue> venues, int totalCount)>
      createElement() {
    return _FetchVenuesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchVenuesProvider &&
        other.sportType == sportType &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sportType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchVenuesRef
    on AutoDisposeFutureProviderRef<(List<Venue> venues, int totalCount)> {
  /// The parameter `sportType` of this provider.
  String? get sportType;

  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchVenuesProviderElement extends AutoDisposeFutureProviderElement<
    (List<Venue> venues, int totalCount)> with FetchVenuesRef {
  _FetchVenuesProviderElement(super.provider);

  @override
  String? get sportType => (origin as FetchVenuesProvider).sportType;
  @override
  int get page => (origin as FetchVenuesProvider).page;
  @override
  int get limit => (origin as FetchVenuesProvider).limit;
}

String _$fetchVenueSlotsHash() => r'e945e74f458d01011ec8f56aa6630bcf71dbaf49';

/// See also [fetchVenueSlots].
@ProviderFor(fetchVenueSlots)
const fetchVenueSlotsProvider = FetchVenueSlotsFamily();

/// See also [fetchVenueSlots].
class FetchVenueSlotsFamily extends Family<AsyncValue<List<Slot>>> {
  /// See also [fetchVenueSlots].
  const FetchVenueSlotsFamily();

  /// See also [fetchVenueSlots].
  FetchVenueSlotsProvider call({
    required String venueId,
    String? date,
  }) {
    return FetchVenueSlotsProvider(
      venueId: venueId,
      date: date,
    );
  }

  @override
  FetchVenueSlotsProvider getProviderOverride(
    covariant FetchVenueSlotsProvider provider,
  ) {
    return call(
      venueId: provider.venueId,
      date: provider.date,
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
  String? get name => r'fetchVenueSlotsProvider';
}

/// See also [fetchVenueSlots].
class FetchVenueSlotsProvider extends AutoDisposeFutureProvider<List<Slot>> {
  /// See also [fetchVenueSlots].
  FetchVenueSlotsProvider({
    required String venueId,
    String? date,
  }) : this._internal(
          (ref) => fetchVenueSlots(
            ref as FetchVenueSlotsRef,
            venueId: venueId,
            date: date,
          ),
          from: fetchVenueSlotsProvider,
          name: r'fetchVenueSlotsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchVenueSlotsHash,
          dependencies: FetchVenueSlotsFamily._dependencies,
          allTransitiveDependencies:
              FetchVenueSlotsFamily._allTransitiveDependencies,
          venueId: venueId,
          date: date,
        );

  FetchVenueSlotsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.venueId,
    required this.date,
  }) : super.internal();

  final String venueId;
  final String? date;

  @override
  Override overrideWith(
    FutureOr<List<Slot>> Function(FetchVenueSlotsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchVenueSlotsProvider._internal(
        (ref) => create(ref as FetchVenueSlotsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        venueId: venueId,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Slot>> createElement() {
    return _FetchVenueSlotsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchVenueSlotsProvider &&
        other.venueId == venueId &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, venueId.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchVenueSlotsRef on AutoDisposeFutureProviderRef<List<Slot>> {
  /// The parameter `venueId` of this provider.
  String get venueId;

  /// The parameter `date` of this provider.
  String? get date;
}

class _FetchVenueSlotsProviderElement
    extends AutoDisposeFutureProviderElement<List<Slot>>
    with FetchVenueSlotsRef {
  _FetchVenueSlotsProviderElement(super.provider);

  @override
  String get venueId => (origin as FetchVenueSlotsProvider).venueId;
  @override
  String? get date => (origin as FetchVenueSlotsProvider).date;
}

String _$fetchVenueByIdHash() => r'f377fbdd4e0b98f61c43367e987b1693bedd1753';

/// See also [fetchVenueById].
@ProviderFor(fetchVenueById)
const fetchVenueByIdProvider = FetchVenueByIdFamily();

/// See also [fetchVenueById].
class FetchVenueByIdFamily extends Family<AsyncValue<Venue>> {
  /// See also [fetchVenueById].
  const FetchVenueByIdFamily();

  /// See also [fetchVenueById].
  FetchVenueByIdProvider call(
    String id,
  ) {
    return FetchVenueByIdProvider(
      id,
    );
  }

  @override
  FetchVenueByIdProvider getProviderOverride(
    covariant FetchVenueByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'fetchVenueByIdProvider';
}

/// See also [fetchVenueById].
class FetchVenueByIdProvider extends AutoDisposeFutureProvider<Venue> {
  /// See also [fetchVenueById].
  FetchVenueByIdProvider(
    String id,
  ) : this._internal(
          (ref) => fetchVenueById(
            ref as FetchVenueByIdRef,
            id,
          ),
          from: fetchVenueByIdProvider,
          name: r'fetchVenueByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchVenueByIdHash,
          dependencies: FetchVenueByIdFamily._dependencies,
          allTransitiveDependencies:
              FetchVenueByIdFamily._allTransitiveDependencies,
          id: id,
        );

  FetchVenueByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Venue> Function(FetchVenueByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchVenueByIdProvider._internal(
        (ref) => create(ref as FetchVenueByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Venue> createElement() {
    return _FetchVenueByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchVenueByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchVenueByIdRef on AutoDisposeFutureProviderRef<Venue> {
  /// The parameter `id` of this provider.
  String get id;
}

class _FetchVenueByIdProviderElement
    extends AutoDisposeFutureProviderElement<Venue> with FetchVenueByIdRef {
  _FetchVenueByIdProviderElement(super.provider);

  @override
  String get id => (origin as FetchVenueByIdProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
