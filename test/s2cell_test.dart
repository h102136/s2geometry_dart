import 'package:test/test.dart';
import 'package:s2geometry_dart/src/latlng_conversion.dart';
import 'package:s2geometry_dart/src/s2cell.dart';

void main() {
  group('S2Cell Tests', () {
    test('fromHilbertQuadKey', () {
      final s2cell = S2Cell.fromHilbertQuadKey('3/210');
      expect(s2cell.face, equals(3));
      expect(s2cell.ij, equals([6, 4]));
      expect(s2cell.level, equals(3));
    });

    test('fromHilbertQuadKey', () {
      final s2cell = S2Cell.fromHilbertQuadKey('3/0123');
      expect(s2cell.face, equals(3));
      expect(s2cell.ij, equals([3, 6]));
      expect(s2cell.level, equals(4));
    });


    test('fromLatLng', () {
      final latLng = LatLng(37.7749, -122.4194); // San Francisco coordinates
      final s2cell = S2Cell.fromLatLng(latLng, 10);
      expect(s2cell.level, equals(10));
    });

    test('toString', () {
      final s2cell = S2Cell(face: 1, ij: [2, 3], level: 5);
      expect(s2cell.toString(), equals('F1 ij[2,3]@5'));
    });

    test('getLatLng', () {
      final s2cell = S2Cell(face: 1, ij: [2, 3], level: 5);
      final latLng = s2cell.getLatLng();
      expect(latLng, isA<LatLng>());
    });

    test('getCornerLatLngs', () {
      final s2cell = S2Cell(face: 1, ij: [2, 3], level: 5);
      final corners = s2cell.getCornerLatLngs();
      expect(corners.length, equals(4));
      expect(corners[0], isA<LatLng>());
    });

    test('toHilbertQuadkey', () {
      final s2cell = S2Cell(face: 3, ij: [6, 4], level: 3);
      final quadkey = s2cell.toHilbertQuadkey();
      expect(quadkey, equals('3/210'));
    });

    test('getNeighbors', () {
      final s2cell = S2Cell(face: 1, ij: [2, 3], level: 5);
      final neighbors = s2cell.getNeighbors();
      expect(neighbors.length, equals(4));
      expect(neighbors[0], isA<S2Cell>());
    });
  });
}