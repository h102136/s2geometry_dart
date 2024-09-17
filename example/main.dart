import 'package:s2geometry_dart/s2geometry_dart.dart';

void main() {
  /// Define latitude, longitude and level
  var lat = 40.2574448;
  var lng = -111.7089464;
  var level = 15;

  /// Convert lat, lng, level to key
  var key = S2.latLngToKey(lat, lng, level);
  print('key: $key');

  /// Convert key to id
  var idFromKey = S2.keyToId(key);
  print('idFromKey: $idFromKey');

  /// Convert lat, lng, level to id
  var idFromLatLng = S2.latLngToId(lat,
      lng); // level defaults to 15, use 'level = 10' to specify level ex.latLngToId(lat, lng, level = 10)
  print('idFromLatLng: $idFromLatLng');

  /// Convert id to key
  var keyFromId = S2.idToKey(idFromKey);
  print('keyFromId: $keyFromId');

  ///  Convert key to lat, lng, level
  var latLngFromKey = S2.keyToLatLng(key);
  print('latLngFromKey: $latLngFromKey');

  /// Convert id to lat, lng, level
  var idToLatLng = S2.idToLatLng(idFromKey);
  print('idToLatLng: $idToLatLng');

  /// Get neighbors based on lat, lng, level
  var neighbors = S2.latLngToNeighborKeys(lat, lng, level);
  print('neighbors: $neighbors');

  /// The next key of the current one
  var nextKey = S2.nextKey(key);
  print('nextKey: $nextKey');

  /// The previous key of the current one
  var prevKey = S2.prevKey(key);
  print('prevKey: $prevKey');

  /// step ten keys back
  var backTenKeys = S2.stepKey(key, -10);
  print('backTenKeys: $backTenKeys');
}
