import 'package:s2geometry_dart/src/latlng_s2point.dart';
import 'package:s2geometry_dart/src/face_uv.dart';
import 'package:s2geometry_dart/src/st_uv.dart';
import 'package:s2geometry_dart/src/ij.dart';
import 'package:s2geometry_dart/src/hilbert_curve.dart';
import 'dart:math';
import 'dart:core';
import 'package:fixnum/fixnum.dart';

class S2 {
  int face;
  List<int> ij;
  int level;

  S2({required this.face, required this.ij, required this.level});

  // Convert Hilbert Quadkey to S2 Cell
  static S2 fromHilbertQuadKey(String hilbertQuadkey) {
    final parts = hilbertQuadkey.split('/'); // Split quadkey as face and position
    final face = int.parse(parts[0]); // Integer representing the face of the S2 Cell
    final position = parts[1]; // String representing the position of the S2 Cell on the face
    final maxLevel = position.length; // Maximum level of the S2 Cell
    final point = {'x': 0, 'y': 0};

    for (int i = maxLevel - 1; i >= 0; i--) {
      final level = maxLevel - i;
      final bit = position[i];
      int rx = 0, ry = 0; // Rotation and flip parameters

      if (bit == '1') {
        ry = 1;
      } else if (bit == '2') {
        rx = 1;
        ry = 1;
      } else if (bit == '3') {
        rx = 1;
      }

      final val = pow(2, level - 1).toInt();
      rotateAndFlipQuadrant(val, point, rx, ry); // Rotate and flip the quadrant

      point['x'] = point['x']! + val * rx;
      point['y'] = point['y']! + val * ry;
    }

    // Adjust the point based on the face (odd faces require swapping x and y)
    if (face % 2 == 1) {
      final t = point['x'];
      point['x'] = point['y']!;
      point['y'] = t!;
    }

    return S2.fromFaceIJ(face, [point['x']!, point['y']!], maxLevel);
  }

  // Convert LatLng to S2 Cell
  static S2 fromLatLng(LatLng latLng, int level) {
    final xyz = S2Point.latLngToXYZ(latLng);
    final faceuv = xyzToFaceUV(xyz);
    final st = uvToST(faceuv[1]);
    final ij = stToIJ(st, level);
    return S2.fromFaceIJ(faceuv[0], ij, level);
  }

  // Create S2 Cell from face, ij, and level
  static S2 fromFaceIJ(int face, List<int> ij, int level) {
    return S2(face: face, ij: ij, level: level);
  }

  // String representation of the S2 Cell
  @override
  String toString() {
    return 'F$face ij[${ij[0]},${ij[1]}]@$level';
  }

  // Convert S2 Cell to LatLng
  LatLng getLatLng() {
    final st = ijToST(ij, level, [0.5.toInt(), 0.5.toInt()]);
    final uv = stToUV(st);
    final xyz = faceUVToXYZ(face, uv);
    return S2Point.xyzToLatLng(xyz);
  }

  // Get 4 corner LatLngs of the S2 Cell
  List<LatLng> getCornerLatLngs() {
    final result = <LatLng>[];
    final offsets = [
      [0.0, 0.0], // Bottom-left
      [0.0, 1.0], // Top-left
      [1.0, 1.0], // Top-right
      [1.0, 0.0]  // Bottom-right
    ];

    for (int i = 0; i < 4; i++) {
      final st = ijToST(ij, level, [offsets[i][0].toInt(), offsets[i][1].toInt()]);
      final uv = stToUV(st);
      final xyz = faceUVToXYZ(face, uv);
      result.add(S2Point.xyzToLatLng(xyz));
    }
    return result;
  }

  // Get face and quads of the S2 Cell
  List<dynamic> getFaceAndQuads() {
    final quads = pointToHilbertQuadList(ij[0], ij[1], level, face);
    return [face, quads];
  }

  // Convert S2 Cell to Hilbert Quadkey
  String toHilbertQuadkey() {
    final quads = pointToHilbertQuadList(ij[0], ij[1], level, face);
    return '$face/${quads.join('')}';
  }

  // Convert LatLng to neighboring Hilbert Quadkeys
  static List<String> latLngToNeighborKeys(double lat, double lng, int level) {
    S2 cell = S2.fromLatLng(LatLng(lat, lng), level);
    return cell.getNeighbors().map((neighbor) => neighbor.toHilbertQuadkey()).toList();
  }

  // Get 4 neighboring S2 Cells
  List<S2> getNeighbors() {
    S2 fromFaceIJWrap(int face, List<int> ij, int level) {
      final maxSize = (1 << level);
      if (ij[0] >= 0 && ij[1] >= 0 && ij[0] < maxSize && ij[1] < maxSize) {
        return S2.fromFaceIJ(face, ij, level);
      } else {
        final st = ijToST(ij, level, [0.5.toInt(), 0.5.toInt()]);
        final uv = stToUV(st);
        final xyz = faceUVToXYZ(face, uv);
        final faceuv = xyzToFaceUV(xyz);
        face = faceuv[0];
        final newUv = faceuv[1];
        final newSt = uvToST(newUv);
        final newIj = stToIJ(newSt, level);
        return S2.fromFaceIJ(face, newIj, level);
      }
    }

    final face = this.face;
    final i = ij[0];
    final j = ij[1];
    final level = this.level;

    return [
      fromFaceIJWrap(face, [i - 1, j], level),
      fromFaceIJWrap(face, [i, j - 1], level),
      fromFaceIJWrap(face, [i + 1, j], level),
      fromFaceIJWrap(face, [i, j + 1], level)
    ];
  }

  // Convert face, position, and level to S2 Cell ID
  static BigInt facePosLevelToId(int faceN, String posS, int? levelN) {
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

    return BigInt.parse(bin, radix: 2); // s2cell id
  }

  // Convert quadkey to S2 Cell ID
  static BigInt keyToId(String key) {
    var parts = key.split('/');
    return facePosLevelToId(int.parse(parts[0]), parts[1], parts[1].length);
  }

  // Convert S2 Cell ID to quadkey
  static String idToKey(BigInt id) {
    var bin = id.toRadixString(2);

    while (bin.length < (faceBITS + posBITS)) {
      bin = '0' + bin;
    }

    var lsbIndex = bin.lastIndexOf('1');
    var faceB = bin.substring(0, 3);
    var posB = bin.substring(3, lsbIndex);
    var levelN = (posB.length / 2).floor();

    var faceS = int.parse(faceB, radix: 2).toString();
    var posS = int.parse(posB, radix: 2).toRadixString(4);

    while (posS.length < levelN) {
      posS = '0' + posS;
    }

    return faceS + '/' + posS;
  }

  // Convert quadkey to LatLng
  static LatLng keyToLatLng(String key) {
    final cell = S2.fromHilbertQuadKey(key);
    return cell.getLatLng();
  }

  // Convert S2 Cell ID to LatLng
  static LatLng idToLatLng(BigInt id) {
    final key = idToKey(id);
    return keyToLatLng(key);
  }

  // Convert LatLng to quadkey
  static String latLngToKey(double lat, double lng, int level) {
    if (level.isNaN || level < 1 || level > 30) {
      throw ArgumentError("'level' is not a number between 1 and 30 (but it should be)");
    }
    return S2.fromLatLng(LatLng(lat, lng), level).toHilbertQuadkey();
  }

  // Convert LatLng to S2 Cell ID
  static BigInt latLngToId(double lat, double lng, {int level = 15}) {
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

  // Constants
  static const int faceBITS = 3;
  static const int maxLEVEL = 30;
  static const int posBITS = (2 * maxLEVEL) + 1; // 61 (60 bits of data, 1 bit lsb marker)
}
