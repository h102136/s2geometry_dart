/* source code from js
var largestAbsComponent = function(xyz) {
  var temp = [Math.abs(xyz[0]), Math.abs(xyz[1]), Math.abs(xyz[2])];

  if (temp[0] > temp[1]) {
    if (temp[0] > temp[2]) {
      return 0;
    } else {
      return 2;
    }
  } else {
    if (temp[1] > temp[2]) {
      return 1;
    } else {
      return 2;
    }
  }

};
*/

// find the component with the largest absolute value in xyz 
int largestAbsComponent(List<double> xyz) {
  List<double> temp = [xyz[0].abs(), xyz[1].abs(), xyz[2].abs()]; 
  // return the index of the largest value
  if (temp[0] > temp[1]) {
    if (temp[0] > temp[2]) {
      return 0;
    } else {
      return 2;
    }
  } else {
    if (temp[1] > temp[2]) {
      return 1;
    } else {
      return 2;
    }
  }
}

/* source code from js
var faceXYZToUV = function(face,xyz) {
  var u,v;

  switch (face) {
    case 0: u =  xyz[1]/xyz[0]; v =  xyz[2]/xyz[0]; break;
    case 1: u = -xyz[0]/xyz[1]; v =  xyz[2]/xyz[1]; break;
    case 2: u = -xyz[0]/xyz[2]; v = -xyz[1]/xyz[2]; break;
    case 3: u =  xyz[2]/xyz[0]; v =  xyz[1]/xyz[0]; break;
    case 4: u =  xyz[2]/xyz[1]; v = -xyz[0]/xyz[1]; break;
    case 5: u = -xyz[1]/xyz[2]; v = -xyz[0]/xyz[2]; break;
    default: throw {error: 'Invalid face'};
  }

  return [u,v];
};
 */
// 'uv' is a 2D point on the cube face, a projection of a 3D point xyz.
// convert xyz on face to uv on face.
List<double> faceXYZToUV(int face, List<double> xyz) { 
  double u, v; // u:The horizontal coordinate, v:The vertical coordinate
  switch (face) {
    case 0: u =  xyz[1] / xyz[0]; v =  xyz[2] / xyz[0]; break;
    case 1: u = -xyz[0] / xyz[1]; v =  xyz[2] / xyz[1]; break;
    case 2: u = -xyz[0] / xyz[2]; v = -xyz[1] / xyz[2]; break;
    case 3: u =  xyz[2] / xyz[0]; v =  xyz[1] / xyz[0]; break;
    case 4: u =  xyz[2] / xyz[1]; v = -xyz[0] / xyz[1]; break;
    case 5: u = -xyz[1] / xyz[2]; v = -xyz[0] / xyz[2]; break;
    default: throw ArgumentError('Invalid face'); // if the face is invalid (not 0-5)
  }

  return [u, v];
}

/* source code from js
S2.XYZToFaceUV = function(xyz) {
  var face = largestAbsComponent(xyz);

  if (xyz[face] < 0) {
    face += 3;
  }

  var uv = faceXYZToUV (face,xyz);

  return [face, uv];
};
 */
// convert xyz to face and uv
List<dynamic> xyzToFaceUV(List<double> xyz) {
  int face = largestAbsComponent(xyz); // determine which face that xyz projects to.

  if (xyz[face] < 0) {
    face += 3; // convert the index of the face to the opposite index.
  }

  List<double> uv = faceXYZToUV(face, xyz);
  return [face, uv];
}

/* source code from js
S2.FaceUVToXYZ = function(face,uv) {
  var u = uv[0];
  var v = uv[1];

  switch (face) {
    case 0: return [ 1, u, v];
    case 1: return [-u, 1, v];
    case 2: return [-u,-v, 1];
    case 3: return [-1,-v,-u];
    case 4: return [ v,-1,-u];
    case 5: return [ v, u,-1];
    default: throw {error: 'Invalid face'};
  }
};
*/
// convert uv to xyz, demtermine the value of xyz based in the face index.
List<double> faceUVToXYZ(int face, List<double> uv) {
  double u = uv[0];
  double v = uv[1];

  switch (face) {
    case 0: return [ 1, u, v];
    case 1: return [-u, 1, v];
    case 2: return [-u, -v, 1];
    case 3: return [-1, -v, -u];
    case 4: return [ v, -1, -u];
    case 5: return [ v, u, -1];
    default: throw ArgumentError('Invalid face');
  }
}