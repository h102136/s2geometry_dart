import 'package:s2geometry_dart/src/s2cell.dart';
import 'package:s2geometry_dart/src/s2_cell_utils.dart';
import 'package:fixnum/fixnum.dart';
void main(){
  final s2cell = S2Cell.fromHilbertQuadKey('3/0123');
  print(s2cell.level); 
  String bin = "110000000000000000000000000000000000000000000000000000000110111";
  print( int.parse(bin, radix: 2).toString());
  print(S2CellUtils.stepKey('3/0123', 1));
}