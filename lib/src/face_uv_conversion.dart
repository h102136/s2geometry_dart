/* find the component with the largest absolute value in the three-dimensional vector, 
and perform calculations and conversions on surfaces, edges, and vertices.*/
int largestAbsComponent(List<double> xyz) {
  List<double> temp = [xyz[0].abs(), xyz[1].abs(), xyz[2].abs()]; // an array of the absolute values 
  // compare the absolute values of x, y, z, and return the index of the largest value
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

// 'uv' is a 2D point on the cube face, a projection of a 3D point xyz.
// 'xyz' is a vector on the cube.
// convert xyz on face to uv coordinates on face.
// requires: face
List<double> faceXYZToUV(int face, List<double> xyz) {
  double u, v; // u:The horizontal coordinate on the 2D plane, v:The vertical coordinate on the 2D plane
  
  
  switch (face) {
    case 0: u =  xyz[1] / xyz[0]; v =  xyz[2] / xyz[0]; break;
    case 1: u = -xyz[0] / xyz[1]; v =  xyz[2] / xyz[1]; break;
    case 2: u = -xyz[0] / xyz[2]; v = -xyz[1] / xyz[2]; break;
    case 3: u =  xyz[2] / xyz[0]; v =  xyz[1] / xyz[0]; break;
    case 4: u =  xyz[2] / xyz[1]; v = -xyz[0] / xyz[1]; break;
    case 5: u = -xyz[1] / xyz[2]; v = -xyz[0] / xyz[2]; break;
    default: throw ArgumentError('Invalid face'); // throw an error if the face is invalid (not 0-5)
  }

  return [u, v];
}

// convert xyz to face and uv
List<dynamic> xyzToFaceUV(List<double> xyz) {
  // calls 'largestAbsComponent' to determine which face that xyz projects to.
  int face = largestAbsComponent(xyz);

  if (xyz[face] < 0) {
    face += 3; // convert the index of the face to the opposite index.
  }
  // get uv coordinates
  List<double> uv = faceXYZToUV(face, xyz);

  return [face, uv];
}

// convert uv coordinates to xyz coordinates, demtermine the value of xyz based in the face index.
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