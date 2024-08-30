import 'package:test/test.dart';
import 'package:s2geometry_dart/src/latlng_conversion.dart';

void main() {
  group('LatLng', () {
    // test for clamping lat/lng
    test('should clamp latitude to -90..90', () {
      final latLng = LatLng(100.0, 90.0);
      expect(latLng.lat, 90.0);  // lat should be clamped to 90
      expect(latLng.lng, 90.0);  // Lng should be wrapped
    });

    test('should wrap longitude to -180..180', () {
      final latLng = LatLng(45.0, 200.0);
      expect(latLng.lat, 45.0);  
      expect(latLng.lng, -160.0); 
    });

    test('should wrap longitude to -180..180 and latitude to -90..90 test2(-100,-200 =>-90,160)', () {
      final latLng = LatLng(-100.0, -200.0);
      expect(latLng.lat, -90.0);  
      expect(latLng.lng, 160.0); 
    });

    test('should wrap longitude to -180..180 and latitude to -90..90 test3(11111,11111 =>90,-49)', () {
      final latLng = LatLng(11111.0, 11111.0);
      expect(latLng.lat, 90.0);  
      expect(latLng.lng, -49.0); 
    });

    // test for invalid lat/lng values
    test('should throw an error for invalid lat/lng values', () {
      expect(() => LatLng('invalid', 90.0), throwsArgumentError);
      expect(() => LatLng(45.0, 'invalid'), throwsArgumentError);
    });

    test('should not wrap latitude and longitude if noWrap is true', () {
      final latLng = LatLng(-100.0, -200.0, noWrap: true);
      expect(latLng.lat, -100.0);  
      expect(latLng.lng, -200.0); 
    });

    test('should convert lat/lng (45.0, 90.0) to XYZ correctly', () {
      final latLng = LatLng(45.0, 90.0);
      final result = LatLng.latLngToXYZ(latLng);

      // assert the expected results for the Cartesian coordinates
      // the precision of the result is 1e-10
      expect(result[0], closeTo(0.0, 1e-10));  // x
      expect(result[1], closeTo(0.70710678118, 1e-10));  // y
      expect(result[2], closeTo(0.70710678118, 1e-10));  // z
    });

    test('should convert lat/lng (-45.0, -90.0)to XYZ correctly', () {
      final latLng = LatLng(-45.0, -90.0);
      final result = LatLng.latLngToXYZ(latLng);

      expect(result[0], closeTo(0.0, 1e-10));  
      expect(result[1], closeTo(-0.70710678118, 1e-10));  
      expect(result[2], closeTo(-0.70710678118, 1e-10));  
    });

    test('should convert XYZ to lat/lng (45.0, 90.0)correctly', () {
      final xyz = [0.0, 0.70710678118, 0.70710678118];
      final result = LatLng.xyzToLatLng(xyz);

      // assert the expected results for the lat/lng
      // the precision of the result is 1e-10
      expect(result.lat, closeTo(45.0, 1e-10));  // lat
      expect(result.lng, closeTo(90.0, 1e-10));  // lng
    });

    test('should convert XYZ to lat/lng (-45.0, -90.0)correctly', () {
      final xyz = [0.0, -0.70710678118, -0.70710678118];
      final result = LatLng.xyzToLatLng(xyz);

      expect(result.lat, closeTo(-45.0, 1e-10)); 
      expect(result.lng, closeTo(-90.0, 1e-10));  
    });

  });
}
