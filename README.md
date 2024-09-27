# s2geometry_dart

- The project is a limited function s2 geometry porting task, to port JavaScript version of S2 Geometry Library to Dart, the porting task is based on the script from  https://www.npmjs.com/package/s2-geometry

- The goal of this porting task is to retain all functionalities in the reference, but split the main script into multiple scripts for enhancing code maintainability and improve testability, and improve user experience so that users can use the package more intuitively and easily.

## Introduction

S2 Geometry is a powerful library developed by Google that provides a framework for working with geometric data on the surface of a sphere. The core idea of S2 Geometry is to project the Earth's surface onto a sphere and subdivide that sphere into hierarchical grids known as S2 Cells. This system enables efficient indexing, querying, and spatial operations like searching for nearby locations, area calculations, and more. S2 Cells are created by recursively subdividing the faces of a cube projected onto the sphere, and they maintain precision across different scales, from global to very fine-grained details.

Google's S2 Geometry library is used in many large-scale applications, including Google Maps, and is widely adopted for solving complex geospatial problems. 

Explore more on:

- http://s2geometry.io/ Official website
- https://squarerfive.com/2023/11/27/why-s2/ Aiden's Blog
- https://blog.christianperone.com/2015/08/googles-s2-geometry-on-the-sphere-cells-and-hilbert-curve/ Terra Incognita
by Christian S. Perone


## Reference

https://www.npmjs.com/package/s2-geometry (javascript)  
https://github.com/google/s2geometry (python)   
https://github.com/google/s2-geometry-library-java (java)  
https://github.com/nbspou/dart-s2geometry (dart)

## Porting plan

1. Target:

    - Functional completeness: Dart version should be able to implement all the functions in JavaScript version
    
    - Convenience of use: Improve the convenience of use and ensure that users can use the package easily without a deep understanding of the internal implementation.

2. Preparation and analysis: 
    - Due to that all function on Javascript version was combined as one script, so the script was split into several functions to improve maintainability.

    - Code test cases for each function to ensure the availability of each function through testing.

3. Process of porting:
    - port modules step by step
        - porting modules one by one according to the module structure of JavaScript version
        - write the test case for the module to ensure that the module is available after porting is complete.
        - integration testing is performed after porting each function to ensure that new modules will not destroy existing functions.
    - integration testing
        - perform the integration testing after porting one function, to ensure that new modules will not destroy existing functions.
4. Testing:  
use `test` package to ensure all the ported functions work as expected. Each function will have its corresponding unit test, and integration tests will be conducted once all functions are ported.
 



## Difficulty of the task

- Differences of language feature: Javascript is a dynamic typing language and Dart is a static typing, so need to check and reconstruct the type of each variable and function.

- Data structure: 'Array' and 'Object' are the most commonly used in JavaScript, 'List' and 'Map' have different ways of use in Dart, so the code needs to be rewritten to accommodate the methods and features of Dart

- Use 'BigInt' to declare S2 cell id for solving the problem of a number over 64 bits.

## Functions available to users

The features to enable users to perform geographic calculations and conversions :

```dart
latLngToXYZ(LatLng latLng) // Convert 'lat', 'lng' to s2 point

fromLatLng(LatLng latLng, int level) // Convert 'lat', 'lng' to s2 cell

latLngToId(lat, lng, [level]) // Converts 'lat', 'lng', 'level' directly to S2 Cell ID. 'level' default to 15, use latLngToId(lat, lng, level = 10) to specific 'level'.

latLngToKey(lat, lng, level) //Converts 'lat', 'lng', 'level' to S2 Cell key.

latLngToNeighborKeys(lat, lng, level) // Convert 'lat', 'lng' to neighboring Hilbert Quadkeys

getLatLng() // Convert s2 cell to 'lat', 'lng', it's non-static method, so you need to create an instance of S2Cell

getCornerLatLngs() // Get 4 corner LatLngs of s2 cell, it's non-static method, so you need to create an instance of S2Cell

getNeighbors() // Get 4 neighboring S2 Cells, it's non-static method, so you need to create an instance of S2Cell

keyToLatLng(key) //Converts S2 Cell key back to lat, lng.

fromHilbertQuadKey(key) // Convert key to s2 cell

keyToId(key) //Converts S2 Cell key to S2 Cell ID.

idToLatLng(id) //Converts S2 Cell ID back to 'lat', 'lng'.

idToKey(id) //Converts S2 Cell ID to key.

latLngToNeighborKeys(lat, lng, level) //Retrieves a list of S2 Cell neighbor keys for a given 'lat' and 'lng' at a specified level.

nextKey(key) //Gets the next S2 Cell key after the current key.

prevKey(key) //Gets the previous S2 Cell key before the current key.

stepKey(key, step) //Moves the current key forward or backward by the specified number of steps.

facePosLevelToId(face, posS, levelN) //Get face and quads list of the S2 Cell, please check demonstration on example

getFaceAndQuads() // Get face and quads list of the S2 Cell, please check demonstration on example

toHilbertQuadkey() //Convert S2 Cell to Hilbert Quadkey, please check demonstration on example
```

## Usage

- add the dependency in 'pubspec.yaml'

```yaml
dependencies:
    s2geometry_dart: ^0.0.3
```
## Example
```dart
import 'package:s2geometry_dart/s2geometry_dart.dart';

void main() {
  /// Define latitude, longitude and level
  var lat = 40.2574448;
  var lng = -111.7089464;
  var latlng = LatLng(lat, lng);
  var level = 15;

  /// Convert lat, lng to s2 point
  var point = S2.latLngToXYZ(latlng);
  print('point: $point');

  ///Convert lat, lng to s2 cell
  var s2cellFromLatLng = S2.fromLatLng(latlng, level);
  print('s2cellFromLatLng: $s2cellFromLatLng');
  
  /// Convert lat, lng, level to id
  var idFromLatLng = S2.latLngToId(lat,lng); // level defaults to 15, use 'level = 10' to specify level ex.latLngToId(lat, lng, level = 10)
  print('idFromLatLng: $idFromLatLng');

  /// Convert lat, lng, level to key
  var key = S2.latLngToKey(lat, lng, level);
  print('key: $key');

  /// Convert lat, lng to neighboring Hilbert Quadkeys
  var neighborsKeysFromLatLng = S2.latLngToNeighborKeys(lat, lng, level);
  print('neighborsKeysFromLatLng: $neighborsKeysFromLatLng');

  /// Convert s2 cell to lat, lng
  var latLngFromS2Cell = s2cellFromLatLng.getLatLng(); ///getLatLng() is non-static method, so you need to create an instance of S2Cell
  print('latLngFromS2Cell: $latLngFromS2Cell');

  /// Get 4 corner LatLngs of s2 cell
  var corners = s2cellFromLatLng.getCornerLatLngs(); ///getCornerLatLngs() is non-static method, so you need to create an instance of S2Cell
  print('corners: $corners');

  /// Get 4 neighboring S2 Cells
  var neighborsFromS2Cell = s2cellFromLatLng.getNeighbors(); ///getNeighbors() is non-static method, so you need to create an instance of S2Cell
  print('neighborsFromS2Cell: $neighborsFromS2Cell');
  
  ///  Convert key to lat, lng, level
  var latLngFromKey = S2.keyToLatLng(key);
  print('latLngFromKey: $latLngFromKey');

  /// Convert key to s2 cell
  var s2cellFromKey = S2.fromHilbertQuadKey(key);
  print('s2cellFromKey: $s2cellFromKey');

  /// Convert key to id
  var idFromKey = S2.keyToId(key);
  print('idFromKey: $idFromKey');

  /// Convert id to lat, lng, level
  var idToLatLng = S2.idToLatLng(idFromKey);
  print('idToLatLng: $idToLatLng');

  /// Convert id to key
  var keyFromId = S2.idToKey(idFromKey);
  print('keyFromId: $keyFromId');

  /// Get neighbors based on lat, lng, level
  var neighbors = S2.latLngToNeighborKeys(lat, lng, level);
  print('neighbors: $neighbors');

  /// The next key of the current one
  var nextKey = S2.nextKey(key);
  print('nextKey: $nextKey');

  /// The previous key of the current one
  var prevKey = S2.prevKey(key);
  print('prevKey: $prevKey');

  /// step ten keys back
  var backTenKeys = S2.stepKey(key, -10);
  print('backTenKeys: $backTenKeys');
  
  /// Convert face, position, and level to S2 Cell ID
  var quadkey = '4/0010023000';
  var parts = quadkey.split('/');
  var face = int.parse(parts[0]);
  var posS = parts[1];
  var levelN = posS.length;

  var idFromFacePosLevel = S2.facePosLevelToId(face, posS, levelN);
  print('idFromFacePosLevel: $idFromFacePosLevel');

  /// Get face and quads list of the S2 Cell
  S2 cell = S2.fromLatLng(latlng, level); // cell = [4, [1107, 8497], 15] face, ij , level
  var faceAndQuads = cell.getFaceAndQuads(); 
  print('faceAndQuads: $faceAndQuads');

  /// Convert S2 Cell to Hilbert Quadkey
  var hilbertQuadkey = cell.toHilbertQuadkey();
  print('hilbertQuadkey: $hilbertQuadkey');
}
```

    

