import 'package:s2geometry_dart/s2geometry.dart';

void main(){
  var lat = 40.2574448;
  var lng = -111.7089464;
  var level = 15;

  var keyFromLatlng = S2.latLngToKey(lat, lng, level);
  print('keyFromLatlng: $keyFromLatlng');

  var idFromKey = S2.keyToId(keyFromLatlng);
  print('idFromKey: $idFromKey');

  var keyFromid = S2.idToKey(idFromKey);
  print('keyFromid: $keyFromid');

  var neighborsKey = S2.latLngToNeighborKeys(lat, lng, level);
  print('neighborsKey: $neighborsKey');

  var nextKey = S2.nextKey(keyFromLatlng);
  print('nextKey: $nextKey');
  var prevKey = S2.prevKey(keyFromLatlng);
  print('prevKey: $prevKey'); 

  var backTenKeys = S2.stepKey(keyFromLatlng, -10);
  print('backTenKeys: $backTenKeys'); 

}

