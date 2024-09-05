import 'package:test/test.dart';
import 'package:s2geometry_dart/src/face_uv.dart';

void main() {
  group('largestAbsComponent', () {
    
    // test for the largest absolute component
    test('should return the index of the largest absolute component', () {
      expect(largestAbsComponent([3.0, -4.0, 2.0]), 1);
      expect(largestAbsComponent([-5.0, 2.0, 3.0]), 0);
      expect(largestAbsComponent([1.0, 2.0, -6.0]), 2);
    });
  });

  group('faceXYZToUV', () {
    test('should convert xyz to uv correctly', () {
      expect(faceXYZToUV(0, [1.0, 2.0, 3.0]), [2.0, 3.0]);
      expect(faceXYZToUV(1, [1.0, 2.0, 3.0]), [-0.5, 1.5]);
      expect(faceXYZToUV(2, [1.0, 2.0, 3.0]), [-0.3333333333333333, -0.6666666666666666]);
    });
  });

  group('xyzToFaceUV', () {
    test('should convert xyz (1.0, 2.0, 3.0)to face and uv correctly', () {
      var result = xyzToFaceUV([1.0, 2.0, 3.0]);
      expect(result[0], 2);
      expect(result[1][0], closeTo(-0.3333333333333333, 1e-9));
      expect(result[1][1], closeTo(-0.6666666666666667, 1e-9));
    });
  });

  group('xyzToFaceUV', () {
    test('should convert xyz(-1.0, -2.0, -3.0) to face and uv  correctly', () {
      var result = xyzToFaceUV([-1.0, -2.0, -3.0]);
      expect(result[0], 5);
      expect(result[1][0], closeTo(-0.6666666666666667, 1e-9));
      expect(result[1][1], closeTo(-0.3333333333333333, 1e-9));
    });
  });
  
  group('faceUVToXYZ', () {
    test('should convert uv to xyz correctly', () {
      expect(faceUVToXYZ(0, [2.0, 3.0]), [1.0, 2.0, 3.0]);
      expect(faceUVToXYZ(1, [-0.5, 1.5]), [0.5, 1.0, 1.5]);
      expect(faceUVToXYZ(2, [-3.0, -2.0]), [3.0, 2.0, 1.0]);
    });
  });
}