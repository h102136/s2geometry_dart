/* source code from js
var pointToHilbertQuadList = function(x,y,order,face) {
  var hilbertMap = {
    'a': [ [0,'d'], [1,'a'], [3,'b'], [2,'a'] ],
    'b': [ [2,'b'], [1,'b'], [3,'a'], [0,'c'] ],
    'c': [ [2,'c'], [3,'d'], [1,'c'], [0,'b'] ],
    'd': [ [0,'a'], [3,'c'], [1,'d'], [2,'d'] ]
  };

  if ('number' !== typeof face) {
    console.warn(new Error("called pointToHilbertQuadList without face value, defaulting to '0'").stack);
  }
  var currentSquare = (face % 2) ? 'd' : 'a';
  var positions = [];

  for (var i=order-1; i>=0; i--) {

    var mask = 1<<i;

    var quad_x = x&mask ? 1 : 0;
    var quad_y = y&mask ? 1 : 0;

    var t = hilbertMap[currentSquare][quad_x*2+quad_y];

    positions.push(t[0]);

    currentSquare = t[1];
  }

  return positions;
};
*/

List<int> pointToHilbertQuadList(int x, int y, int order, int face) {
  
  if (face < 0) {
    throw Exception("Invalid face value: face cannot be negative");
  }
  // Hilbert curve map, a,b,c,d are the four quadrants
  // each quadrant have 4 sub-quadrants
  // [0,'d'] means the next quadrant is d, and the position is 0
  const hilbertMap = {
    'a': [ [0, 'd'], [1, 'a'], [3, 'b'], [2, 'a'] ],
    'b': [ [2, 'b'], [1, 'b'], [3, 'a'], [0, 'c'] ],
    'c': [ [2, 'c'], [3, 'd'], [1, 'c'], [0, 'b'] ],
    'd': [ [0, 'a'], [3, 'c'], [1, 'd'], [2, 'd'] ]
  };
  
  String currentSquare = (face % 2 == 1) ? 'd' : 'a'; // if face is odd, start at 'd', else start at 'a'
  List<int> positions = [];

  // iterate through each bit in the hilbert curve
   for (int i = order - 1; i >= 0; i--) {
    int mask = 1 << i;

    int quadX = (x & mask) != 0 ? 1 : 0;
    int quadY = (y & mask) != 0 ? 1 : 0;

    var t = hilbertMap[currentSquare];
    if (t != null) {
      var quadData = t[quadX * 2 + quadY];
      positions.add(quadData[0] as int);
      currentSquare = quadData[1] as String;
    } else {
      throw Exception("Invalid currentSquare or hilbertMap data");
    }
  }

  return positions;
}