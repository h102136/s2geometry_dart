import 'package:s2geometry_dart/src/lat_lng_conversion.dart';
import 'package:s2geometry_dart/src/face_uv_conversion.dart';
import 'package:s2geometry_dart/src/st_uv_conversion.dart';
import 'package:s2geometry_dart/src/ij_conversion.dart';
import 'package:s2geometry_dart/src/hilbert_curve.dart';
import 'dart:math';

class S2Cell {
  int face;
  List<int> ij;
  int level;

  S2Cell({required this.face, required this.ij, required this.level});

  // convert Hilbert Quadkey to S2 Cell
  static S2Cell fromHilbertQuadKey(String hilbertQuadkey) {
    final parts = hilbertQuadkey.split('/'); // split quadkey as face and position
    final face = int.parse(parts[0]); // an integer representing the face of the S2 Cell
    final position = parts[1]; // a string representing the position of the S2 Cell on the face
    final maxLevel = position.length; // the maximum level of the S2 Cell
    final point = {'x': 0, 'y': 0};

    for (int i = maxLevel - 1; i >= 0; i--) {
      final level = maxLevel - i;
      final bit = position[i];
      int rx = 0, ry = 0; // the rotation and flip parameters

      if (bit == '1') {
        ry = 1;
      } else if (bit == '2') {
        rx = 1;
        ry = 1;
      } else if (bit == '3') {
        rx = 1;
      }

      final val = pow(2, level - 1).toInt();
      rotateAndFlipQuadrant(val, point, rx, ry); // rotate and flip the quadrant
      // update the point      
       
      point['x'] = point['x']! + val * rx;
      point['y'] = point['y']! + val * ry;
         
    }
    // adjust the point based on the face (odd faces require swapping x and y)
    if (face % 2 == 1) {
      final t = point['x'];
      point['x'] = point['y']!;
      point['y'] = t!;
    }
    // return the S2 Cell
    return S2Cell.fromFaceIJ(face, [point['x']!, point['y']!], maxLevel);
  }

  // accept a LatLng object and a level and return the S2 Cell
  static S2Cell fromLatLng(LatLng latLng, int level) {
    final xyz = LatLng.latLngToXYZ(latLng);
    final faceuv = xyzToFaceUV(xyz);
    final st = uvToST(faceuv[1]);
    final ij = stToIJ(st, level);
    return S2Cell.fromFaceIJ(faceuv[0], ij, level);
  }

  // accept a face, ij, and level and return the S2 Cell
  static S2Cell fromFaceIJ(int face, List<int> ij, int level) {
    return S2Cell(face: face, ij: ij, level: level);
  }

  // return the string representation of the S2 Cell
  @override
  String toString() {
    return 'F$face ij[${ij[0]},${ij[1]}]@$level';
  }

  // return the LatLng object of the S2 Cell
  LatLng getLatLng() {
    final st = ijToST(ij, level, [0.5.toInt(), 0.5.toInt()]);
    final uv = stToUV(st);
    final xyz = faceUVToXYZ(face, uv);
    return LatLng.xyzToLatLng(xyz);
  }

  // return an array of 4 corner LatLng objects
  List<LatLng> getCornerLatLngs() {
    final result = <LatLng>[]; // store the corner LatLng objects
    final offsets = [ // the offsets for each corner
      [0.0, 0.0], // bottom-left
      [0.0, 1.0], // top-left
      [1.0, 1.0], // top-right
      [1.0, 0.0]  // bottom-right
    ];
    // iterate through each corner
    for (int i = 0; i < 4; i++) {
      final st = ijToST(ij, level, [offsets[i][0].toInt(), offsets[i][1].toInt()]);
      final uv = stToUV(st);
      final xyz = faceUVToXYZ(face, uv);
      result.add(LatLng.xyzToLatLng(xyz));
    }
    return result;
  }

  // return the face and an array of quads
  List<dynamic> getFaceAndQuads() {
    final quads = pointToHilbertQuadList(ij[0], ij[1], level, face);
    return [face, quads];
  }

  // return the Hilbert Quadkey of the S2 Cell
  String toHilbertQuadkey() {
    final quads = pointToHilbertQuadList(ij[0], ij[1], level, face);
    return '$face/${quads.join('')}';
  }

  // return an array of 4 S2 Cells representing the neighbors of the S2 Cell
  List<S2Cell> getNeighbors() {
    S2Cell fromFaceIJWrap(int face, List<int> ij, int level) {
      final maxSize = (1 << level);
      if (ij[0] >= 0 && ij[1] >= 0 && ij[0] < maxSize && ij[1] < maxSize) {
        return S2Cell.fromFaceIJ(face, ij, level);
      } else {
        final st = ijToST(ij, level, [0.5.toInt(), 0.5.toInt()]);
        final uv = stToUV(st);
        final xyz = faceUVToXYZ(face, uv);
        final faceuv = xyzToFaceUV(xyz);
        face = faceuv[0];
        final newUv = faceuv[1];
        final newSt = uvToST(newUv);
        final newIj = stToIJ(newSt, level);
        return S2Cell.fromFaceIJ(face, newIj, level);
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
}