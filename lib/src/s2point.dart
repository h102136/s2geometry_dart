import 'package:s2geometry_dart/src/latlng_conversion.dart';

class S2Point {
  final double x;
  final double y;
  final double z;

  S2Point(this.x, this.y, this.z);

  @override
  String toString() => 'S2Point(x: $x, y: $y, z: $z)';

  fromLatLng(LatLng latLng) {
    List<double> xyz = LatLng.latLngToXYZ(latLng);
    return S2Point(xyz[0], xyz[1], xyz[2]);
  }

  LatLng toLatLng() {
    return LatLng.xyzToLatLng([x, y, z]);
  }
}