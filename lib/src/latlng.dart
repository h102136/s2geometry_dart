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
/// LatLng class ensures that lat and lng values are valid
class LatLng {
  double lat;
  double lng;

  /// Conversion constants between degrees and radians
  static const double degToRad = math.pi / 180;
  static const double radToDeg = 180 / math.pi;

  /// Constructor
  LatLng(dynamic rawLat, dynamic rawLng, {bool noWrap = false})
      :

        /// Initialize lat and lng
        lat = double.tryParse(rawLat.toString()) ?? double.nan,

        /// Convert to double, set to NaN if invalid
        lng = double.tryParse(rawLng.toString()) ?? double.nan {
    /// Check if lat and lng are valid
    if (lat.isNaN || lng.isNaN) {
      throw ArgumentError('Invalid LatLng object: ($rawLat, $rawLng)');

      /// Throw error if invalid
    }

    if (!noWrap) {
      lat = lat.clamp(-90, 90);
      lng = (lng + 180) % 360 - 180;

      /// Wrap lng to -180..180 if noWrap is false
    }
  }

  /// Override toString method to display lat and lng values
  @override
  String toString() {
    return 'LatLng(lat: $lat, lng: $lng)';
  }
}

