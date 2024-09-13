import 'package:test/test.dart';
import 'package:s2geometry_dart/s2geometry_dart.dart';

void main() {
  group('S2 Geometry Tests', () {
    test('Convert lat, lng, level to key', () {
      var lat = 40.2574448;
      var lng = -111.7089464;
      var level = 15;
      var key = S2.latLngToKey(lat, lng, level);
      expect(key, isNotNull);
    });

    test('Convert key to id', () {
      var key = S2.latLngToKey(40.2574448, -111.7089464, 15);
      var idFromKey = S2.keyToId(key);
      expect(idFromKey, isNotNull);
    });

    test('Convert lat, lng, level to id', () {
      var idFromLatLng = S2.latLngToId(40.2574448, -111.7089464);
      expect(idFromLatLng, isNotNull);
    });

    test('Convert id to key', () {
      var key = S2.latLngToKey(40.2574448, -111.7089464, 15);
      var idFromKey = S2.keyToId(key);
      var keyFromId = S2.idToKey(idFromKey);
      expect(keyFromId, isNotNull);
    });

    test('Convert key to lat, lng, level', () {
      var key = S2.latLngToKey(40.2574448, -111.7089464, 15);
      var latLngFromKey = S2.keyToLatLng(key);
      expect(latLngFromKey, isNotNull);
    });

    test('Convert id to lat, lng, level', () {
      var key = S2.latLngToKey(40.2574448, -111.7089464, 15);
      var idFromKey = S2.keyToId(key);
      var idToLatLng = S2.idToLatLng(idFromKey);
      expect(idToLatLng, isNotNull);
    });

    test('Get neighbors based on lat, lng, level', () {
      var neighbors = S2.latLngToNeighborKeys(40.2574448, -111.7089464, 15);
      expect(neighbors, isNotEmpty);
    });

    test('Get next key', () {
      var key = S2.latLngToKey(40.2574448, -111.7089464, 15);
      var nextKey = S2.nextKey(key);
      expect(nextKey, isNotNull);
    });

    test('Get previous key', () {
      var key = S2.latLngToKey(40.2574448, -111.7089464, 15);
      var prevKey = S2.prevKey(key);
      expect(prevKey, isNotNull);
    });

    test('Step ten keys back', () {
      var key = S2.latLngToKey(40.2574448, -111.7089464, 15);
      var backTenKeys = S2.stepKey(key, -10);
      expect(backTenKeys, isNotNull);
    });
  });
}