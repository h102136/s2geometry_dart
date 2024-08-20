import 'dart:math' as math;

class LatLng {
  double lat; // as float, declare 'lat' ,'lng' that the attribute expected to be used in the class
  double lng; 

  // mutual conversion of degrees and radians 
  static const double degToRad = math.pi / 180; //The number of radians corresponding to each degree
  static const double radToDeg = 180 / math.pi; //The degree corresponding to each radian

  // Constructor
  LatLng(dynamic rawLat, dynamic rawLng, {bool noWrap = false}/* default lat, lng will be wrapped and clamped*/  ): 
    // initialize lat and lng 
    lat = double.tryParse(rawLat.toString()) ?? double.nan, // convert to double, if not possible, set to NaN
    lng = double.tryParse(rawLng.toString()) ?? double.nan

    // check if lat and lng are valid
  {
    if (lat.isNaN || lng.isNaN) {
      throw ArgumentError('Invalid LatLng object: ($rawLat, $rawLng)'); // throw error if invalid
    }

    // wrap and clamp lat and lng
    // (!noWrap) is true, run the statement
    if (!noWrap) {
      lat = lat.clamp(-90, 90);
      lng = ((lng + 180) % 360 + 360) % 360 - 180;
    }
  }

  // convert lat,lng to Cartesian coordinates(three dimensions x, y, z)
  static List<double> latLngToXYZ(LatLng latLng) {
    double d2r = degToRad;

    double phi = latLng.lat * d2r; // radian of lat
    double theta = latLng.lng * d2r; // radian of lng

    double cosphi = math.cos(phi); 

    return [math.cos(theta) * cosphi/*x*/, math.sin(theta) * cosphi/*y*/, math.sin(phi)/*z*/];
  }

  // convert Cartesian coordinates to lat,lng
  static LatLng xyzToLatLng(List<double> xyz) {
    double r2d = radToDeg;

    double lat = math.atan2(xyz[2], math.sqrt(xyz[0] * xyz[0] + xyz[1] * xyz[1]));
    double lng = math.atan2(xyz[1], xyz[0]);

    return LatLng(lat * r2d, lng * r2d);
  }
}
