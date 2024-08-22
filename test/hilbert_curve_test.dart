import 'package:test/test.dart';
import 'package:s2geometry_dart/src/hilbert_curve.dart'; 
void main() {
  group('HilbertCurve', () {
    test('Should return correct positions for x=0, y=0, order=2, face=0', () {
      List<int> result = pointToHilbertQuadList(0, 0, 2, 0);
      expect(result, equals([0, 0]));
    });

    test('Should return correct positions for x=1, y=2, order=2, face=1', () {
      List<int> result = pointToHilbertQuadList(1, 2, 2, 1);
      expect(result, equals([3, 1]));
    });

    test('Should throw exception for invalid currentSquare', () {
      expect(() => pointToHilbertQuadList(1, 2, 2, -1), throwsException);
    });
  });
}
