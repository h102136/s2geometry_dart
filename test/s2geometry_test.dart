import 'package:test/test.dart';
import 'package:s2geometry_dart/src/latlng_s2point.dart';
import 'package:s2geometry_dart/s2geometry.dart';

void main() {
  group('S2Cell Tests', () {
    test('fromHilbertQuadKey', () {
      final s2cell = S2.fromHilbertQuadKey('3/210');
      expect(s2cell.face, equals(3));
      expect(s2cell.ij, equals([6, 4]));
      expect(s2cell.level, equals(3));
    });

    test('fromHilbertQuadKey', () {
      final s2cell = S2.fromHilbertQuadKey('3/0123');
      expect(s2cell.face, equals(3));
      expect(s2cell.ij, equals([3, 6]));
      expect(s2cell.level, equals(4));
    });


    test('fromLatLng', () {
      final latLng = LatLng(37.7749, -122.4194); 
      final s2cell = S2.fromLatLng(latLng, 10);
      expect(s2cell.level, equals(10));
    });

    test('toString', () {
      final s2cell = S2(face: 1, ij: [2, 3], level: 5);
      expect(s2cell.toString(), equals('F1 ij[2,3]@5'));
    });

    test('getLatLng', () {
      final s2cell = S2(face: 1, ij: [2, 3], level: 5);
      final latLng = s2cell.getLatLng();
      expect(latLng, isA<LatLng>());
    });

    test('getCornerLatLngs', () {
      final s2cell = S2(face: 1, ij: [2, 3], level: 5);
      final corners = s2cell.getCornerLatLngs();
      expect(corners.length, equals(4));
      expect(corners[0], isA<LatLng>());
    });

    test('toHilbertQuadkey', () {
      final s2cell = S2(face: 3, ij: [6, 4], level: 3);
      final quadkey = s2cell.toHilbertQuadkey();
      expect(quadkey, equals('3/210'));
    });

    test('getNeighbors', () {
      final s2cell = S2(face: 1, ij: [2, 3], level: 5);
      final neighbors = s2cell.getNeighbors();
      expect(neighbors.length, equals(4));
      expect(neighbors[0], isA<S2>());
    });

    test('latLngToKey', () {
      var lat = 37.7749;
      var lng = -122.4194;
      var level = 10;
      expect(S2.latLngToKey(lat, lng, level), '4/0010023000');
    });

    test('keyToLatLng', () {
      var key = '4/0010023000';
      var expectedLat = 37.7749;
      var expectedLng = -122.4194;
      var actualLatLng = S2.keyToLatLng(key);
      expect(actualLatLng.lat, closeTo(expectedLat, 0.1));
      expect(actualLatLng.lng, closeTo(expectedLng, 0.1));
    });

    test('keyToId', () {
      var key = '4/0010023000';
      var expectedId = BigInt.parse('9260950045757276160'); 
      expect(S2.keyToId(key), expectedId);
    });

    test('idToKey', () {
      var id = BigInt.parse('9260950045757276160');  
      var expectedKey = '4/0010023000';
      expect(S2.idToKey(id), expectedKey);
    });

    test('idToLatLng', () {
      var id = BigInt.parse('9260950045757276160');  
      var expectedLat = 37.7749;
      var expectedLng = -122.4194;
      var actualLatLng = S2.idToLatLng(id);
      expect(actualLatLng.lat, closeTo(expectedLat, 0.1));
      expect(actualLatLng.lng, closeTo(expectedLng, 0.1));
    });

    test('facePosLevelToId', () {
      var face = 1;
      var pos = '130';
      var level = 3;
      var expectedId = BigInt.parse('3332663724254167040');  
      expect(S2.facePosLevelToId(face, pos, level), expectedId);
    });

    test('prevKey', () {
      var key = '1/130';
      var expectedKey = '1/123'; 
      expect(S2.prevKey(key), expectedKey);
    });

    test('nextKey', () {
      var key = '1/130';
      var expectedKey = '1/131'; 
      expect(S2.nextKey(key), expectedKey);
    });

    test('stepKey', () {
      var key = '1/130';
      var num = 3;
      var expectedKey = '1/133'; 
      expect(S2.stepKey(key, num), expectedKey);
    });

    test('stepKey', () {
      var key = '1/130';
      var num = -3;
      var expectedKey = '1/121'; 
      expect(S2.stepKey(key, num), expectedKey);
    });
  });

}