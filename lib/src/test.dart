import 'package:s2geometry_dart/src/s2cell.dart';

void main(){
  final s2cell = S2Cell.fromHilbertQuadKey('3/0123');
  print(s2cell.level); // 3
}