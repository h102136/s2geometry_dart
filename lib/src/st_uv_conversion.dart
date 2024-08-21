import 'dart:math';
// 'st' is a point that is projected from a sphere to a unit square on a two-dimensional plane.
// convert st to uv
double singleSTtoUV(double st) {
  if (st >= 0.5) {
    return (1 / 3.0) * (4 * st * st - 1);
  } else {
    return (1 / 3.0) * (1 - (4 * (1 - st) * (1 - st)));
  }
}

// convert st to uv
List<double> stToUV(List<double> st) {
  return [singleSTtoUV(st[0]), singleSTtoUV(st[1])];
}

// convert single st to single uv
double singleUVtoST(double uv) {
  if (uv >= 0) {
    return 0.5 * sqrt(1 + 3 * uv);
  } else {
    return 1 - 0.5 * sqrt(1 - 3 * uv);
  }
}

// convert uv to st
List<double> uvToST(List<double> uv) {
  return [singleUVtoST(uv[0]), singleUVtoST(uv[1])];
}