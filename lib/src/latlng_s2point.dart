import 'dart:math' as math;

class LatLng {
  double lat; // Latitude
  double lng; // Longitude

  // Conversion constants between degrees and radians
  static const double degToRad = math.pi / 180; // Degrees to radians
  static const double radToDeg = 180 / math.pi; // Radians to degrees

  // Constructor
  LatLng(dynamic rawLat, dynamic rawLng, {bool noWrap = false}) :
    // Initialize lat and lng
    lat = double.tryParse(rawLat.toString()) ?? double.nan, // Convert to double, set to NaN if invalid
    lng = double.tryParse(rawLng.toString()) ?? double.nan {
    
    // Check if lat and lng are valid
    if (lat.isNaN || lng.isNaN) {
      throw ArgumentError('Invalid LatLng object: ($rawLat, $rawLng)'); // Throw error if invalid
    }

    // Wrap lng to -180..180 if noWrap is false
    if (!noWrap) {
      lat = lat.clamp(-90, 90);
      lng = (lng + 180) % 360 - 180;
    }
  }

  // Override toString method to display lat and lng values
  @override
  String toString() {
    return 'LatLng(lat: $lat, lng: $lng)';
  }
}

class S2Point{
  // Convert lat,lng to 3D point (x, y, z)
  static List<double> latLngToXYZ(LatLng latLng) {
    double d2r = LatLng.degToRad;

    double phi = latLng.lat * d2r; // Latitude in radians
    double theta = latLng.lng * d2r; // Longitude in radians

    double cosphi = math.cos(phi);

    return [
      math.cos(theta) * cosphi, // x
      math.sin(theta) * cosphi, // y
      math.sin(phi) // z
    ];
  }

  // Convert 3D point (x, y, z) to lat,lng
  static LatLng xyzToLatLng(List<double> xyz) {
    double r2d = LatLng.radToDeg;

    double lat = math.atan2(xyz[2], math.sqrt(xyz[0] * xyz[0] + xyz[1] * xyz[1]));
    double lng = math.atan2(xyz[1], xyz[0]);

    return LatLng(lat * r2d, lng * r2d);
  }
}