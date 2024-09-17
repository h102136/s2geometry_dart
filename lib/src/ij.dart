import 'dart:math';

/* source code from js
S2.STToIJ = function(st,order) {
  var maxSize = (1<<order);

  var singleSTtoIJ = function(st) {
    var ij = Math.floor(st * maxSize);
    return Math.max(0, Math.min(maxSize-1, ij));
  };

  return [singleSTtoIJ(st[0]), singleSTtoIJ(st[1])];
};
*/
/// ij is a point on a cell in a 2D grid.
// /convert st to ij
List<int> stToIJ(List<double> st, int order) {
  /// order: the level of the S2 cell
  int maxSize = 1 << order;

  /// maxSize: number of cells in each dimension

  /// let st project from a range [0, 1] to the range [0, maxSize], then get the floor value of the result
  int singleSTtoIJ(double st) {
    int ij = (st * maxSize).floor();
    return max(
        0, min(maxSize - 1, ij)); //make sure ij is in the range [0, maxSize)
  }

  return [singleSTtoIJ(st[0]), singleSTtoIJ(st[1])];
}

/* source code from js
S2.IJToST = function(ij,order,offsets) {
  var maxSize = (1<<order);

  return [
    (ij[0]+offsets[0])/maxSize,
    (ij[1]+offsets[1])/maxSize
  ];
};
*/
/// convert ij to st
List<double> ijToST(
    List<int> ij, int order, List<int> offsets /*a list of two integers*/) {
  int maxSize = 1 << order;

  return [
    (ij[0] + offsets[0]) /
        maxSize, // divide by maxSize to scale the range to [0, 1]
    (ij[1] + offsets[1]) / maxSize
  ];
}

/* source code from js
var rotateAndFlipQuadrant = function(n, point, rx, ry)
{
	var newX, newY;
	if(ry == 0)
	{
		if(rx == 1){
			point.x = n - 1 - point.x;
			point.y = n - 1 - point.y

		}

    var x = point.x;
		point.x = point.y
		point.y = x;
	}

} 
*/
/// rotate and flip points for given parameters
void rotateAndFlipQuadrant(int n, Map<String, int> point, int rx, int ry) {
  point['x'] ??= 0;
  point['y'] ??= 0;
  if (ry == 0) {
    if (rx == 1) {
      point['x'] = n - 1 - point['x']!;

      /// map x from range 0 to n-1 transform to n-1 to 0.
      point['y'] = n - 1 - point['y']!;

      /// same as above
    }

    /// Swap x and y
    int x = point['x']!;
    point['x'] = point['y']!;
    point['y'] = x;
  }
}
