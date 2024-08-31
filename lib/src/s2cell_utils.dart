import 'package:fixnum/fixnum.dart';
import 's2cell.dart';
import 'lat_lng_conversion.dart';

class S2CellUtils {
  static const int faceBITS = 3;
  static const int maxLEVEL = 30;
  static const int posBITS = (2 * maxLEVEL) + 1; // 61 (60 bits of data, 1 bit lsb marker)

  // Convert face, position, and level to S2 Cell ID
  static String facePosLevelToId(int faceN, String posS, int? levelN) {
    String faceB;
    String posB;
    String bin;

    levelN ??= posS.length;
    if (posS.length > levelN) {
      posS = posS.substring(0, levelN);
    }

    // 3-bit face value
    faceB = Int64.parseInt(faceN.toString()).toRadixString(2);
    while (faceB.length < faceBITS) {
      faceB = '0' + faceB;
    }

    // 60-bit position value
    posB = Int64(int.parse(posS, radix: 4)).toRadixString(2);
    while (posB.length < (2 * levelN)) {
      posB = '0' + posB;
    }
    bin = faceB + posB;
    // 1-bit lsb marker
    bin += '1';
    // n-bit padding to 64-bits
    while (bin.length < (faceBITS + posBITS)) {
      bin += '0';
    }

    return int.parse(bin, radix: 2).toString(); // s2cell id
  }

  // Convert quadkey to S2 Cell ID
  static String keyToId(String key) {
    var parts = key.split('/');
    return facePosLevelToId(int.parse(parts[0]), parts[1], parts[1].length);
  }

  // Convert S2 Cell ID to quadkey
  static String idToKey(String idS) {
    var bin = BigInt.parse(idS).toRadixString(2);

    while (bin.length < (faceBITS + posBITS)) {
      bin = '0' + bin;
    }

    var lsbIndex = bin.lastIndexOf('1');
    var faceB = bin.substring(0, 3);
    var posB = bin.substring(3, lsbIndex);
    var levelN = (posB.length / 2).floor();

    var faceS = int.parse(faceB, radix:2).toString();
    var posS = int.parse(posB, radix:2).toRadixString(4);

    while (posS.length < levelN) {
      posS = '0' + posS;
    }

    return faceS + '/' + posS;
  }

  // Convert quadkey to LatLng
  static LatLng keyToLatLng(String key) {
    final cell = S2Cell.fromHilbertQuadKey(key);
    return cell.getLatLng();
  }

  // Convert S2 Cell ID to LatLng
  static LatLng idToLatLng(String id) {
    final key = idToKey(id);
    return keyToLatLng(key);
  }

  // Convert LatLng to quadkey
  static String latLngToKey(double lat, double lng, int level) {
    if (level.isNaN || level < 1 || level > 30) {
      throw ArgumentError("'level' is not a number between 1 and 30 (but it should be)");
    }
    return S2Cell.fromLatLng(LatLng(lat, lng), level).toHilbertQuadkey();
  }

  // Convert LatLng to S2 Cell ID
  static String latLngToId(double lat, double lng, {int level = 15}) {
    String hilbertQuadkey = latLngToKey(lat, lng, level);
    return keyToId(hilbertQuadkey);
  }

  // Stepping operation for quadkey
  static String stepKey(String key, int num) {
    var parts = key.split('/');
    var faceS = parts[0];
    var posS = parts[1];
    var level = parts[1].length;

    var posL = int.parse(posS, radix: 4); // Translate posS to base 10
    int otherL;
    if (num > 0) {
      otherL = posL + num.abs();
    } else if (num < 0) {
      otherL = posL - num.abs();
    } else {
      otherL = posL;
    }
    var otherS = otherL.toRadixString(4);

    if (otherS == '0') {
      print("Warning: face/position wrapping is not yet supported");
    }
    while (otherS.length < level) {
      otherS = '0' + otherS;
    }

    return faceS + '/' + otherS;
  }

  // Calculate the previous Hilbert QuadKey
  static String prevKey(String key) {
    return stepKey(key, -1);
  }

  // Calculate the next Hilbert QuadKey
  static String nextKey(String key) {
    return stepKey(key, 1);
  }
}
