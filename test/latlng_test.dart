import 'package:test/test.dart';
import 'package:s2geometry_dart/src/latlng.dart';

void main() {
  //test cases for LatLng class
  group('LatLng, S2point', () {
    test('should create a LatLng object with lat,lng', () {
      final latLng = LatLng(45.0, 90.0);
      expect(latLng.lat, 45.0);
      expect(latLng.lng, 90.0);
    });

    test('should throw an error for invalid lat,lng values', () {
      expect(() => LatLng('invalid', 90.0), throwsArgumentError);
      expect(() => LatLng(45.0, 'invalid'), throwsArgumentError);
    });

    test('should clamp lat to -90..90', () {
      final latLng = LatLng(100.0, 90.0);
      expect(latLng.lat, 90.0);
      expect(latLng.lng, 90.0);
    });

    test('should wrap lng to -180..180', () {
      final latLng = LatLng(45.0, 200.0);
      expect(latLng.lat, 45.0);
      expect(latLng.lng, -160.0);
    });

    test(
        'should wrap lng to -180..180 and lat to -90..90 (-100,-200 =>-90,160)',
        () {
      final latLng = LatLng(-100.0, -200.0);
      expect(latLng.lat, -90.0);
      expect(latLng.lng, 160.0);
    });

    test(
        'should wrap longitude to -180..180 and latitude to -90..90 (11111,11111 =>90,-49)',
        () {
      final latLng = LatLng(11111.0, 11111.0);
      expect(latLng.lat, 90.0);
      expect(latLng.lng, -49.0);
    });

    test('should not wrap lat and lng if noWrap is true', () {
      final latLng = LatLng(-100.0, -200.0, noWrap: true);
      expect(latLng.lat, -100.0);
      expect(latLng.lng, -200.0);
    });

  });
}
