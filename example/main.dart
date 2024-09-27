import 'package:s2geometry_dart/s2geometry_dart.dart';

void main() {
  /// Define latitude, longitude and level
  var lat = 40.2574448;
  var lng = -111.7089464;
  var latlng = LatLng(lat, lng);
  var level = 15;

  /// Convert lat, lng to s2 point
  var point = S2.latLngToXYZ(latlng);
  print('point: $point');

  ///Convert lat, lng to s2 cell
  var s2cellFromLatLng = S2.fromLatLng(latlng, level);
  print('s2cellFromLatLng: $s2cellFromLatLng');
  
  /// Convert lat, lng, level to id
  var idFromLatLng = S2.latLngToId(lat,lng); // level defaults to 15, use 'level = 10' to specify level ex.latLngToId(lat, lng, level = 10)
  print('idFromLatLng: $idFromLatLng');

  /// Convert lat, lng, level to key
  var key = S2.latLngToKey(lat, lng, level);
  print('key: $key');

  /// Convert lat, lng to neighboring Hilbert Quadkeys
  var neighborsKeysFromLatLng = S2.latLngToNeighborKeys(lat, lng, level);
  print('neighborsKeysFromLatLng: $neighborsKeysFromLatLng');

  /// Convert s2 cell to lat, lng
  var latLngFromS2Cell = s2cellFromLatLng.getLatLng(); ///getLatLng() is non-static method, so you need to create an instance of S2Cell
  print('latLngFromS2Cell: $latLngFromS2Cell');

  /// Get 4 corner LatLngs of s2 cell
  var corners = s2cellFromLatLng.getCornerLatLngs(); ///getCornerLatLngs() is non-static method, so you need to create an instance of S2Cell
  print('corners: $corners');

  /// Get 4 neighboring S2 Cells
  var neighborsFromS2Cell = s2cellFromLatLng.getNeighbors(); ///getNeighbors() is non-static method, so you need to create an instance of S2Cell
  print('neighborsFromS2Cell: $neighborsFromS2Cell');
  
  ///  Convert key to lat, lng, level
  var latLngFromKey = S2.keyToLatLng(key);
  print('latLngFromKey: $latLngFromKey');

  /// Convert key to s2 cell
  var s2cellFromKey = S2.fromHilbertQuadKey(key);
  print('s2cellFromKey: $s2cellFromKey');

  /// Convert key to id
  var idFromKey = S2.keyToId(key);
  print('idFromKey: $idFromKey');

  /// Convert id to lat, lng, level
  var idToLatLng = S2.idToLatLng(idFromKey);
  print('idToLatLng: $idToLatLng');

  /// Convert id to key
  var keyFromId = S2.idToKey(idFromKey);
  print('keyFromId: $keyFromId');

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
  
  /// Convert face, position, and level to S2 Cell ID
  var quadkey = '4/0010023000';
  var parts = quadkey.split('/');
  var face = int.parse(parts[0]);
  var posS = parts[1];
  var levelN = posS.length;

  var idFromFacePosLevel = S2.facePosLevelToId(face, posS, levelN);
  print('idFromFacePosLevel: $idFromFacePosLevel');

  /// Get face and quads list of the S2 Cell
  S2 cell = S2.fromLatLng(latlng, level); // cell = [4, [1107, 8497], 15] face, ij , level
  var faceAndQuads = cell.getFaceAndQuads(); 
  print('faceAndQuads: $faceAndQuads');

  /// Convert S2 Cell to Hilbert Quadkey
  var hilbertQuadkey = cell.toHilbertQuadkey();
  print('hilbertQuadkey: $hilbertQuadkey');
}
