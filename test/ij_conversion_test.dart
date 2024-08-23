import 'package:test/test.dart';
import 'package:s2geometry_dart/src/ij_conversion.dart';

void main() {
  group('stToIJ', () {
    test('should convert st to ij correctly', () {
      expect(stToIJ([0.5, 0.5], 3), [4, 4]);
      expect(stToIJ([0.0, 0.0], 2), [0, 0]);
      expect(stToIJ([0.75, 0.25], 3), [6, 2]);
      expect(stToIJ([1.0, 1.0], 2), [3, 3]);
    });
  });

  group('ijToST', () {
    test('should convert ij to st correctly', () {
      expect(ijToST([2, 2], 2, [1, 1]), [0.75, 0.75]);
      expect(ijToST([3, 3], 3, [2, 2]), [0.625, 0.625]);
      expect(ijToST([4, 4], 3, [0, 0]), [0.5, 0.5]);
      expect(ijToST([6, 2], 3, [0, 0]), [0.75, 0.25]);
    });
  });

  group('rotateAndFlipQuadrant', () {
    test('should rotate and flip points correctly', () {
      var point = {'x': 1, 'y': 2};
      rotateAndFlipQuadrant(4, point, 1, 0);
      expect(point, {'x': 1, 'y': 2});

      point = {'x': 1, 'y': 2};
      rotateAndFlipQuadrant(4, point, 0, 1);
      expect(point, {'x': 1, 'y': 2});

      point = {'x': 1, 'y': 2};
      rotateAndFlipQuadrant(4, point, 1, 1);
      expect(point, {'x': 1, 'y': 2});
    });
  });
}