import 'package:test/test.dart';
import 'package:s2geometry_dart/src/s2_cell_utils.dart'; 

void main() {
  group('S2CellUtils', () {

    test('latLngToKey', () {
      var lat = 37.7749;
      var lng = -122.4194;
      var level = 10;
      expect(S2CellUtils.latLngToKey(lat, lng, level), '4/0010023000');
    });

    test('keyToLatLng', () {
      var key = '4/0010023000';
      var expectedLat = 37.7749;
      var expectedLng = -122.4194;
      var actualLatLng = S2CellUtils.keyToLatLng(key);
      expect(actualLatLng.lat, closeTo(expectedLat, 0.1));
      expect(actualLatLng.lng, closeTo(expectedLng, 0.1));
    });

    test('keyToId', () {
      var key = '4/0010023000';
      var expectedId = '9260950045757276160'; 
      expect(S2CellUtils.keyToId(key), expectedId);
    });

    test('idToKey', () {
      var id = '9260950045757276160'; 
      var expectedKey = '4/0010023000';
      expect(S2CellUtils.idToKey(id), expectedKey);
    });

    test('idToLatLng', () {
      var id = '9260950045757276160'; 
      var expectedLat = 37.7749;
      var expectedLng = -122.4194;
      var actualLatLng = S2CellUtils.idToLatLng(id);
      expect(actualLatLng.lat, closeTo(expectedLat, 0.1));
      expect(actualLatLng.lng, closeTo(expectedLng, 0.1));
    });

    test('facePosLevelToId', () {
      var face = 1;
      var pos = '130';
      var level = 3;
      var expectedId = '3332663724254167040'; 
      expect(S2CellUtils.facePosLevelToId(face, pos, level), expectedId);
    });


    test('prevKey', () {
      var key = '1/130';
      var expectedKey = '1/123'; 
      expect(S2CellUtils.prevKey(key), expectedKey);
    });

    test('nextKey', () {
      var key = '1/130';
      var expectedKey = '1/131'; 
      expect(S2CellUtils.nextKey(key), expectedKey);
    });

    test('stepKey', () {
      var key = '1/130';
      var num = 3;
      var expectedKey = '1/133'; 
      expect(S2CellUtils.stepKey(key, num), expectedKey);
    });

    test('stepKey', () {
      var key = '1/130';
      var num = -3;
      var expectedKey = '1/121'; 
      expect(S2CellUtils.stepKey(key, num), expectedKey);
    });
  });
}