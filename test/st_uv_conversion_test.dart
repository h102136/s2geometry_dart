import 'package:test/test.dart';
import 'package:s2geometry_dart/src/st_uv_conversion.dart'; 

void main() {
  group('STUVConversion tests', () {
    test('singleSTtoUV converts st to uv correctly', () {
      expect(singleSTtoUV(0.5), closeTo(0, 1e-9));
      expect(singleSTtoUV(1), closeTo(1, 1e-9));
      expect(singleSTtoUV(0), closeTo(-1, 1e-9));
      expect(singleSTtoUV(0.75), closeTo(0.4166666666666666, 1e-9));
    });

    test('STToUV converts st array to uv array correctly', () {
      expect(stToUV([0.5, 0.5]), [closeTo(0, 1e-9), closeTo(0, 1e-9)]);
      expect(stToUV([1, 1]), [closeTo(1, 1e-9), closeTo(1, 1e-9)]);
      expect(stToUV([0, 0]), [closeTo(-1, 1e-9), closeTo(-1, 1e-9)]);
      expect(stToUV([0.75, 0.25]), [closeTo(0.4166666666666666, 1e-9), closeTo(-0.4166666666666666, 1e-9)]);
    });

    test('singleUVtoST converts uv to st correctly', () {
      expect(singleUVtoST(0), closeTo(0.5, 1e-9));
      expect(singleUVtoST(1), closeTo(1, 1e-9));
      expect(singleUVtoST(-1), closeTo(0, 1e-9));
      expect(singleUVtoST(0.5), closeTo(0.79056, 1e-5));
    });

    test('UVToST converts uv array to st array correctly', () {
      expect(uvToST([0, 0]), [closeTo(0.5, 1e-9), closeTo(0.5, 1e-9)]);
      expect(uvToST([1, 1]), [closeTo(1, 1e-9), closeTo(1, 1e-9)]);
      expect(uvToST([-1, -1]), [closeTo(0, 1e-9), closeTo(0, 1e-5)]);
      expect(uvToST([0.5, -0.5]), [closeTo(0.79056, 1e-5), closeTo(0.20943, 1e-5)]);
    });
  });
}