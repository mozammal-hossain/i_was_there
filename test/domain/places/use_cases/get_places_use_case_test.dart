import 'package:flutter_test/flutter_test.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/domain/places/repositories/place_repository.dart';
import 'package:i_was_there/domain/places/use_cases/get_places_use_case.dart';

void main() {
  group('GetPlacesUseCase', () {
    late GetPlacesUseCase useCase;
    late FakePlaceRepository repository;

    setUp(() {
      repository = FakePlaceRepository();
      useCase = GetPlacesUseCase(repository);
    });

    test('returns places from repository', () async {
      final places = [
        const Place(
          id: '1',
          name: 'Office',
          address: '123 Main St',
          latitude: 0,
          longitude: 0,
        ),
        const Place(
          id: '2',
          name: 'Home',
          address: '456 Oak Ave',
          latitude: 1,
          longitude: 1,
        ),
      ];
      repository.placesToReturn = places;

      final result = await useCase.call();

      expect(result, equals(places));
      expect(result.length, 2);
      expect(result[0].name, 'Office');
      expect(result[1].name, 'Home');
    });

    test('returns empty list when repository has no places', () async {
      repository.placesToReturn = [];

      final result = await useCase.call();

      expect(result, isEmpty);
    });

    test('propagates repository exceptions', () async {
      repository.shouldThrow = true;

      expect(() => useCase.call(), throwsA(isA<Exception>()));
    });
  });
}

/// Fake [PlaceRepository] for unit tests.
class FakePlaceRepository implements PlaceRepository {
  List<Place> placesToReturn = [];
  bool shouldThrow = false;

  @override
  Future<List<Place>> getPlaces() async {
    if (shouldThrow) throw Exception('Fake repository error');
    return placesToReturn;
  }

  @override
  Future<Place?> getPlace(String id) async => null;

  @override
  Future<void> addPlace(Place place) async {}

  @override
  Future<void> updatePlace(Place place) async {}

  @override
  Future<void> removePlace(String id) async {}
}
