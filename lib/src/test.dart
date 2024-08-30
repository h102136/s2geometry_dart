import 'package:s2geometry_dart/src/s2cell.dart';
import 'package:s2geometry_dart/src/s2_cell_utils.dart';
import 'package:s2geometry_dart/src/s2_utils.dart';
import 'package:s2geometry_dart/src/latlng_conversion.dart';
import 'package:s2geometry_dart/src/s2_utils.dart';
void main(){
  // final s2cell = S2Cell.fromHilbertQuadKey('3/0123');
  // print(s2cell.level); 
  // String bin = "110000000000000000000000000000000000000000000000000000000110111";
  // print( int.parse(bin, radix: 2).toString());
  // print(S2CellUtils.stepKey('3/0123', 1));
  // print(S2CellUtils.latLngToKey(37.7749, -122.4194, 10));
  // var key = '4/0010023000';
  // var latLng=S2CellUtils.keyToLatLng(key);
  // print(latLng.lat);
  // print(latLng.lng);
  // var key2 = '4/0010023000';  
  // var id = S2CellUtils.keyToId(key2);
  // print(id);
  // var id2 = '9260950045757276160';
  // print(S2CellUtils.idToKey(id2));
  // var id = S2CellUtils.facePosLevelToId(1, '130', 3);
  // print(id);
  String getS2CellId(double lat, double lng, {int level = 15}) {
  // 使用 S2CellUtils 计算 LatLng 对应的 Hilbert QuadKey
  LatLng latLng = LatLng(lat, lng);
  var cell = S2Cell.fromLatLng(latLng, 15);
  print(cell);
  // 将 Hilbert QuadKey 转换为 S2 Cell ID
  String s2CellId = S2CellUtils.facePosLevelToId(cell.face, cell.toHilbertQuadkey().split('/')[1], cell.level);
  print(s2CellId);
  return s2CellId;
  }
  getS2CellId(45, 90);
}