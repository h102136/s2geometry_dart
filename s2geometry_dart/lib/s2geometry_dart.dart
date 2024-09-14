import 'package:s2geometry_dart/src/latlng_s2point.dart';
import 'package:s2geometry_dart/src/face_uv.dart';
import 'package:s2geometry_dart/src/st_uv.dart';
import 'package:s2geometry_dart/src/ij.dart';
import 'package:s2geometry_dart/src/hilbert_curve.dart';
import 'dart:math';
import 'dart:core';
import 'package:fixnum/fixnum.dart';


  /* source code from js
  S2.S2Cell = function(){};
  S2.S2Cell.FromHilbertQuadKey = function(hilbertQuadkey) {
    var parts = hilbertQuadkey.split('/');
    var face = parseInt(parts[0]);
    var position = parts[1];
    var maxLevel = position.length;
    var point = {
      x : 0,
      y: 0
    };
    var i;
    var level;
    var bit;
    var rx, ry;
    var val;

    for(i = maxLevel - 1; i >= 0; i--) {

      level = maxLevel - i;
      bit = position[i];
      rx = 0;
      ry = 0;
      if (bit === '1') {
        ry = 1;
      }
      else if (bit === '2') {
        rx = 1;
        ry = 1;
      }
      else if (bit === '3') {
        rx = 1;
      }

      val = Math.pow(2, level - 1);
      rotateAndFlipQuadrant(val, point, rx, ry);

      point.x += val * rx;
      point.y += val * ry;

    }

    if (face % 2 === 1) {
      var t = point.x;
      point.x = point.y;
      point.y = t;
    }


    return S2.S2Cell.FromFaceIJ(parseInt(face), [point.x, point.y], level);
  };
  */
class S2 {
  int face;
  List<int> ij;
  int level;

  S2({required this.face, required this.ij, required this.level});
  // Convert Hilbert Quadkey to S2 Cell
  static S2 fromHilbertQuadKey(String hilbertQuadkey) {
    final parts = hilbertQuadkey.split('/'); 
    final face = int.parse(parts[0]); 
    final position = parts[1]; 
    final maxLevel = position.length; 
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

  /* source code from js
  S2.S2Cell.FromFaceIJ = function(face,ij,level) {
    var cell = new S2.S2Cell();
    cell.face = face;
    cell.ij = ij;
    cell.level = level;

    return cell;
  };
   */
  // Create S2 Cell from face, ij, and level
  static S2 fromFaceIJ(int face, List<int> ij, int level) {
    return S2(face: face, ij: ij, level: level);
  }

  /* source code from js
  S2.S2Cell.FromLatLng = function(latLng, level) {
    if ((!latLng.lat && latLng.lat !== 0) || (!latLng.lng && latLng.lng !== 0)) {
      throw new Error("Pass { lat: lat, lng: lng } to S2.S2Cell.FromLatLng");
    }
    var xyz = S2.LatLngToXYZ(latLng);

    var faceuv = S2.XYZToFaceUV(xyz);
    var st = S2.UVToST(faceuv[1]);

    var ij = S2.STToIJ(st,level);

    return S2.S2Cell.FromFaceIJ (faceuv[0], ij, level);
  }; 
  */
  // Convert LatLng to S2 Cell
  static S2 fromLatLng(LatLng latLng, int level) {
    final xyz = S2Point.latLngToXYZ(latLng);
    final faceuv = xyzToFaceUV(xyz);
    final st = uvToST(faceuv[1]);
    final ij = stToIJ(st, level);
    return S2.fromFaceIJ(faceuv[0], ij, level);
  }

  /* source code from js
  S2.S2Cell.prototype.toString = function() {
    return 'F'+this.face+'ij['+this.ij[0]+','+this.ij[1]+']@'+this.level;
  };
  */
  // String representation of the S2 Cell
  @override
  String toString() {
    return 'F$face ij[${ij[0]},${ij[1]}]@$level';
  }

  /* source code from js
  S2.S2Cell.prototype.getLatLng = function() {
    var st = S2.IJToST(this.ij,this.level, [0.5,0.5]);
    var uv = S2.STToUV(st);
    var xyz = S2.FaceUVToXYZ(this.face, uv);

    return S2.XYZToLatLng(xyz);
  };
  */
  // Convert S2 Cell to LatLng
  LatLng getLatLng() {
    final st = ijToST(ij, level, [0.5.toInt(), 0.5.toInt()]);
    final uv = stToUV(st);
    final xyz = faceUVToXYZ(face, uv);
    return S2Point.xyzToLatLng(xyz);
  }

  /* source code from js
  S2.S2Cell.prototype.getCornerLatLngs = function() {
    var result = [];
    var offsets = [
      [ 0.0, 0.0 ],
      [ 0.0, 1.0 ],
      [ 1.0, 1.0 ],
      [ 1.0, 0.0 ]
    ];

    for (var i=0; i<4; i++) {
      var st = S2.IJToST(this.ij, this.level, offsets[i]);
      var uv = S2.STToUV(st);
      var xyz = S2.FaceUVToXYZ(this.face, uv);

      result.push ( S2.XYZToLatLng(xyz) );
    }
    return result;
  };
  */
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

  /* source code from js
  S2.S2Cell.prototype.getFaceAndQuads = function () {
    var quads = pointToHilbertQuadList(this.ij[0], this.ij[1], this.level, this.face);

    return [this.face,quads];
  };
  */
  // Get face and quads of the S2 Cell
  List<dynamic> getFaceAndQuads() {
    final quads = pointToHilbertQuadList(ij[0], ij[1], level, face);
    return [face, quads];
  }

  /* source code from js
  S2.S2Cell.prototype.toHilbertQuadkey = function () {
    var quads = pointToHilbertQuadList(this.ij[0], this.ij[1], this.level, this.face);

    return this.face.toString(10) + '/' + quads.join('');
  };
  */
  // Convert S2 Cell to Hilbert Quadkey
  String toHilbertQuadkey() {
    final quads = pointToHilbertQuadList(ij[0], ij[1], level, face);
    return '$face/${quads.join('')}';
  }

  /* source code from js
  S2.latLngToNeighborKeys = S2.S2Cell.latLngToNeighborKeys = function (lat, lng, level) {
    return S2.S2Cell.FromLatLng({ lat: lat, lng: lng }, level).getNeighbors().map(function (cell) {
      return cell.toHilbertQuadkey();
    });
  };
  */
  // Convert LatLng to neighboring Hilbert Quadkeys
  static List<String> latLngToNeighborKeys(double lat, double lng, int level) {
    S2 cell = S2.fromLatLng(LatLng(lat, lng), level);
    return cell.getNeighbors().map((neighbor) => neighbor.toHilbertQuadkey()).toList();
  }
  /* source code from js
  S2.S2Cell.prototype.getNeighbors = function() {

    var fromFaceIJWrap = function(face,ij,level) {
      var maxSize = (1<<level);
      if (ij[0]>=0 && ij[1]>=0 && ij[0]<maxSize && ij[1]<maxSize) {
        // no wrapping out of bounds
        return S2.S2Cell.FromFaceIJ(face,ij,level);
      } else {
        // the new i,j are out of range.
        // with the assumption that they're only a little past the borders we can just take the points as
        // just beyond the cube face, project to XYZ, then re-create FaceUV from the XYZ vector

        var st = S2.IJToST(ij,level,[0.5,0.5]);
        var uv = S2.STToUV(st);
        var xyz = S2.FaceUVToXYZ(face,uv);
        var faceuv = S2.XYZToFaceUV(xyz);
        face = faceuv[0];
        uv = faceuv[1];
        st = S2.UVToST(uv);
        ij = S2.STToIJ(st,level);
        return S2.S2Cell.FromFaceIJ (face, ij, level);
      }
    };

    var face = this.face;
    var i = this.ij[0];
    var j = this.ij[1];
    var level = this.level;


    return [
      fromFaceIJWrap(face, [i-1,j], level),
      fromFaceIJWrap(face, [i,j-1], level),
      fromFaceIJWrap(face, [i+1,j], level),
      fromFaceIJWrap(face, [i,j+1], level)
    ];

  };
  */
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

  /* source code from js
  S2.FACE_BITS = 3;
  S2.MAX_LEVEL = 30;
  S2.POS_BITS = (2 * S2.MAX_LEVEL) + 1; // 61 (60 bits of data, 1 bit lsb marker)

  S2.facePosLevelToId = S2.S2Cell.facePosLevelToId = S2.fromFacePosLevel = function (faceN, posS, levelN) {
    var Long = exports.dcodeIO && exports.dcodeIO.Long || require('long');
    var faceB;
    var posB;
    var bin;

    if (!levelN) {
      levelN = posS.length;
    }
    if (posS.length > levelN) {
      posS = posS.substr(0, levelN);
    }

    // 3-bit face value
    faceB = Long.fromString(faceN.toString(10), true, 10).toString(2);
    while (faceB.length < S2.FACE_BITS) {
      faceB = '0' + faceB;
    }

    // 60-bit position value
    posB = Long.fromString(posS, true, 4).toString(2);
    while (posB.length < (2 * levelN)) {
      posB = '0' + posB;
    }

    bin = faceB + posB;
    // 1-bit lsb marker
    bin += '1';
    // n-bit padding to 64-bits
    while (bin.length < (S2.FACE_BITS + S2.POS_BITS)) {
      bin += '0';
    }

    return Long.fromString(bin, true, 2).toString(10);
  };
  */
  // Constants
  static const int faceBITS = 3;
  static const int maxLEVEL = 30;
  static const int posBITS = (2 * maxLEVEL) + 1; // 61 (60 bits of data, 1 bit lsb marker)
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
      faceB = '0$faceB';
    }

    // 60-bit position value
    posB = Int64(int.parse(posS, radix: 4)).toRadixString(2);
    while (posB.length < (2 * levelN)) {
      posB = '0$posB';
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

  /* source code from js
  S2.keyToId = S2.S2Cell.keyToId
  = S2.toId = S2.toCellId = S2.fromKey
  = function (key) {
    var parts = key.split('/');

    return S2.fromFacePosLevel(parts[0], parts[1], parts[1].length);
  };
  */
  // Convert quadkey to S2 Cell ID
  static BigInt keyToId(String key) {
    var parts = key.split('/');
    return facePosLevelToId(int.parse(parts[0]), parts[1], parts[1].length);
  }

  /* source code from js
  S2.keyToId = S2.S2Cell.keyToId
  S2.idToKey = S2.S2Cell.idToKey
  = S2.S2Cell.toKey = S2.toKey
  = S2.fromId = S2.fromCellId
  = S2.S2Cell.toHilbertQuadkey  = S2.toHilbertQuadkey
  = function (idS) {
    var Long = exports.dcodeIO && exports.dcodeIO.Long || require('long');
    var bin = Long.fromString(idS, true, 10).toString(2);

    while (bin.length < (S2.FACE_BITS + S2.POS_BITS)) {
      bin = '0' + bin;
    }

    // MUST come AFTER binstr has been left-padded with '0's
    var lsbIndex = bin.lastIndexOf('1');
    // substr(start, len)
    // substring(start, end) // includes start, does not include end
    var faceB = bin.substring(0, 3);
    // posB will always be a multiple of 2 (or it's invalid)
    var posB = bin.substring(3, lsbIndex);
    var levelN = posB.length / 2;

    var faceS = Long.fromString(faceB, true, 2).toString(10);
    var posS = Long.fromString(posB, true, 2).toString(4);

    while (posS.length < levelN) {
      posS = '0' + posS;
    }

    return faceS + '/' + posS;
  };
  */
  // Convert S2 Cell ID to quadkey
  static String idToKey(BigInt id) {
    var bin = id.toRadixString(2);

    while (bin.length < (faceBITS + posBITS)) {
      bin = '0$bin';
    }

    var lsbIndex = bin.lastIndexOf('1');
    var faceB = bin.substring(0, 3);
    var posB = bin.substring(3, lsbIndex);
    var levelN = (posB.length / 2).floor();

    var faceS = int.parse(faceB, radix: 2).toString();
    var posS = int.parse(posB, radix: 2).toRadixString(4);

    while (posS.length < levelN) {
      posS = '0$posS';
    }

    return '$faceS/$posS';
  }

  /* source code from js
  S2.keyToLatLng = S2.S2Cell.keyToLatLng = function (key) {
    var cell2 = S2.S2Cell.FromHilbertQuadKey(key);
    return cell2.getLatLng();
  };
  */
  // Convert quadkey to LatLng
  static LatLng keyToLatLng(String key) {
    final cell = S2.fromHilbertQuadKey(key);
    return cell.getLatLng();
  }

  /* source code from js
  S2.idToLatLng = S2.S2Cell.idToLatLng = function (id) {
    var key = S2.idToKey(id);
    return S2.keyToLatLng(key);
  };
  */
  // Convert S2 Cell ID to LatLng
  static LatLng idToLatLng(BigInt id) {
    final key = idToKey(id);
    return keyToLatLng(key);
  }

  /* source code from js
  S2.S2Cell.latLngToKey = S2.latLngToKey
  = S2.latLngToQuadkey = function (lat, lng, level) {
    if (isNaN(level) || level < 1 || level > 30) {
      throw new Error("'level' is not a number between 1 and 30 (but it should be)");
    }
    return S2.S2Cell.FromLatLng({ lat: lat, lng: lng }, level).toHilbertQuadkey();
  };
  */
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

  /* source code from js
  S2.stepKey = function (key, num) {
    var Long = exports.dcodeIO && exports.dcodeIO.Long || require('long');
    var parts = key.split('/');

    var faceS = parts[0];
    var posS = parts[1];
    var level = parts[1].length;

    var posL = Long.fromString(posS, true, 4);
    // TODO handle wrapping (0 === pos + 1)
    // (only on the 12 edges of the globe)
    var otherL;
    if (num > 0) {
      otherL = posL.add(Math.abs(num));
    }
    else if (num < 0) {
      otherL = posL.subtract(Math.abs(num));
    }
    var otherS = otherL.toString(4);

    if ('0' === otherS) {
      console.warning(new Error("face/position wrapping is not yet supported"));
    }

    while (otherS.length < level) {
      otherS = '0' + otherS;
    }

    return faceS + '/' + otherS;
  };
  */
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
      otherS = '0$otherS';
    }

    return '$faceS/$otherS';
  }

  /*  source code from js
  S2.S2Cell.prevKey = S2.prevKey = function (key) {
    return S2.stepKey(key, -1);
  };
  */
  // Calculate the previous Hilbert QuadKey
  static String prevKey(String key) {
    return stepKey(key, -1);
  }

  /* source code from js
  S2.S2Cell.nextKey = S2.nextKey = function (key) {
    return S2.stepKey(key, 1);
  };
  */
  // Calculate the next Hilbert QuadKey
  static String nextKey(String key) {
    return stepKey(key, 1);
  }
}
