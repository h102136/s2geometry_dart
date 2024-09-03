import 'dart:math' as math;

/* source code from js

(function (exports) {
'use strict';
var S2 = exports.S2 = { L: {} };

S2.L.LatLng = function (/*Number*/ rawLat, /*Number*/ rawLng, /*Boolean*/ noWrap) {
  var lat = parseFloat(rawLat, 10);
  var lng = parseFloat(rawLng, 10);

  if (isNaN(lat) || isNaN(lng)) {
    throw new Error('Invalid LatLng object: (' + rawLat + ', ' + rawLng + ')');
  }

  if (noWrap !== true) {
    lat = Math.max(Math.min(lat, 90), -90);                 // clamp latitude into -90..90
    lng = (lng + 180) % 360 + ((lng < -180 || lng === 180) ? 180 : -180);   // wrap longtitude into -180..180
  }

  return { lat: lat, lng: lng };
};

S2.L.LatLng.DEG_TO_RAD = Math.PI / 180;
S2.L.LatLng.RAD_TO_DEG = 180 / Math.PI;
*/

// LatLng class ensures that lat and lng values are valid
class LatLng {
  double lat; 
  double lng; 

  // Conversion constants between degrees and radians
  static const double degToRad = math.pi / 180; 
  static const double radToDeg = 180 / math.pi; 

  // Constructor
  LatLng(dynamic rawLat, dynamic rawLng, {bool noWrap = false}) :
    // Initialize lat and lng
    lat = double.tryParse(rawLat.toString()) ?? double.nan, // Convert to double, set to NaN if invalid
    lng = double.tryParse(rawLng.toString()) ?? double.nan {
    
      // Check if lat and lng are valid
      if (lat.isNaN || lng.isNaN) {
        throw ArgumentError('Invalid LatLng object: ($rawLat, $rawLng)'); // Throw error if invalid
        }

      if (!noWrap) {
        lat = lat.clamp(-90, 90);
        lng = (lng + 180) % 360 - 180; // Wrap lng to -180..180 if noWrap is false
        }
    }

    // Override toString method to display lat and lng values
    @override
    String toString() {
      return 'LatLng(lat: $lat, lng: $lng)';
    }
}
/* source code from js
S2.LatLngToXYZ = function(latLng) {
  var d2r = S2.L.LatLng.DEG_TO_RAD;

  var phi = latLng.lat*d2r;
  var theta = latLng.lng*d2r;

  var cosphi = Math.cos(phi);

  return [Math.cos(theta)*cosphi, Math.sin(theta)*cosphi, Math.sin(phi)];
};

S2.XYZToLatLng = function(xyz) {
  var r2d = S2.L.LatLng.RAD_TO_DEG;

  var lat = Math.atan2(xyz[2], Math.sqrt(xyz[0]*xyz[0]+xyz[1]*xyz[1]));
  var lng = Math.atan2(xyz[1], xyz[0]);

  return S2.L.LatLng(lat*r2d, lng*r2d);
};
*/

// S2Point class contains static methods to convert between LatLng and 3D coordinates(xyz)
class S2Point{
  
  // Convert lat,lng to 3D point (x, y, z)
  static List<double> latLngToXYZ(LatLng latLng) {
    double d2r = LatLng.degToRad;

    double phi = latLng.lat * d2r; 
    double theta = latLng.lng * d2r; 

    double cosphi = math.cos(phi);

    return [
      math.cos(theta) * cosphi, //x
      math.sin(theta) * cosphi, //y
      math.sin(phi) //z
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