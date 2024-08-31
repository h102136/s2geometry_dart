import 'package:s2geometry_dart/src/s2cell.dart';
import 'package:s2geometry_dart/src/s2cell_utils.dart';
void main(){
  var lat = 40.2574448;
  var lng = -111.7089464;
  var level = 15;
  
  var key = S2CellUtils.latLngToKey(lat, lng, level);
  print(key);

  var id = S2CellUtils.keyToId(key);
  print(id);

  var key2 = S2CellUtils.idToKey(id);
  print(key2);

  var neighbors = S2Cell.latLngToNeighborKeys(lat, lng, level);
  print(neighbors);

  var nextKey = S2CellUtils.nextKey(key);
  print(nextKey);
  var prevKey = S2CellUtils.prevKey(key);
  print(prevKey); 

  var backTenKeys = S2CellUtils.stepKey(key, -10);
  print(backTenKeys); 

}