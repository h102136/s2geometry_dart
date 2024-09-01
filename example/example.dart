import 'package:s2geometry_dart/s2geometry.dart';
void main(){
  var lat = 40.2574448;
  var lng = -111.7089464;
  var level = 15;
  
  var key = S2.latLngToKey(lat, lng, level);
  print(key);

  var id = S2.keyToId(key);
  print(id);

  var key2 = S2.idToKey(id);
  print(key2);

  var neighbors = S2.latLngToNeighborKeys(lat, lng, level);
  print(neighbors);

  var nextKey = S2.nextKey(key);
  print(nextKey);
  var prevKey = S2.prevKey(key);
  print(prevKey); 

  var backTenKeys = S2.stepKey(key, -10);
  print(backTenKeys); 

}

