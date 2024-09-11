import 'package:s2geometry_dart/s2geometry.dart';

void main(){

  // Define latitude, longitude and level
  var lat = 40.2574448;
  var lng = -111.7089464;
  var level = 15;
  
  // Convert lat and lng to key 
  var key = S2.latLngToKey(lat, lng, level);
  print(key);

  // Convert key to s2cell id 
  var idFromKey = S2.keyToId(key);
  print(idFromKey);

  var keyFromId = S2.idToKey(idFromKey);
  print(keyFromId);

  //Get neighbors based on lat, lng, level
  var neighbors = S2.latLngToNeighborKeys(lat, lng, level);
  print(neighbors);
  
  //The next key of the current one
  var nextKey = S2.nextKey(key);
  print(nextKey);
  //The previous key of the current one
  var prevKey = S2.prevKey(key);
  print(prevKey); 
  
  //step ten keys back 
  var backTenKeys = S2.stepKey(key, -10);
  print(backTenKeys); 

}