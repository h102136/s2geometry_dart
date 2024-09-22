# s2geometry_dart

- The project is to port JavaScript version of S2 Geometry Library to Dart, the porting task is based on the script from  https://www.npmjs.com/package/s2-geometry

- The goal of this porting task is to retain all functionalities in the reference, but split the main script into multiple scripts for enhancing code maintainability and improve testability, and improve user experience so that users can use the package more intuitively and easily.

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
Port test cases of Javascript version into Dart version and ensure all tests pass 



## Difficulty of the task

- Differences of language feature: Javascript is a dynamic typing language and Dart is a static typing, so need to check and reconstruct the type of each variable and function.

- Data structure: 'Array' and 'Object' are the most commonly used in JavaScript, 'List' and 'Map' have different ways of use in Dart, so the code needs to be rewritten to accommodate the methods and features of Dart

- Use 'BigInt' to declare S2 cell id for solving the problem of a number over 64 bits.

## Functions available to users

The features to enable users to perform geographic calculations and conversions :

```dart
latLngToKey(lat, lng, level) //Converts 'lat', 'lng', 'level' to S2 Cell key.

keyToId(key) //Converts S2 Cell key to S2 Cell ID.

latLngToId(lat, lng, [level]) //Converts 'lat', 'lng', 'level' directly to S2 Cell ID. 'level' default to 15, use latLngToId(lat, lng, level = 10) to specific 'level'.

idToKey(id) //Converts S2 Cell ID to key.

keyToLatLng(key) //Converts S2 Cell key back to lat, lng.

idToLatLng(id) //Converts S2 Cell ID back to 'lat', 'lng'.

latLngToNeighborKeys(lat, lng, level) //Retrieves a list of S2 Cell neighbor keys for a given 'lat' and 'lng' at a specified level.

nextKey(key) //Gets the next S2 Cell key after the current key.

prevKey(key) //Gets the previous S2 Cell key before the current key.

stepKey(key, step) //Moves the current key forward or backward by the specified number of steps.
```

## Usage

- add the dependency in 'pubspec.yaml'

```yaml
dependencies:
    s2geometry_dart: ^0.0.2
```
## Example
```dart
import 'package:s2geometry_dart/s2geometry_dart.dart';

void main(){

  /// Define latitude, longitude and level
  var lat = 40.2574448;
  var lng = -111.7089464;
  var level = 15;
  
  /// Convert lat, lng, level to key 
  var key = S2.latLngToKey(lat, lng, level);
  print('key: $key');

  /// Convert key to id 
  var idFromKey = S2.keyToId(key);
  print('idFromKey: $idFromKey');

  /// Convert lat, lng, level to id 
  var idFromLatLng = S2.latLngToId(lat, lng); // level defaults to 15, use 'level = 10' to specify level ex.latLngToId(lat, lng, level = 10)
  print('idFromLatLng: $idFromLatLng');
  

  /// Convert id to key
  var keyFromId = S2.idToKey(idFromKey);
  print('keyFromId: $keyFromId');

  ///  Convert key to lat, lng, level
  var latLngFromKey = S2.keyToLatLng(key);
  print('latLngFromKey: $latLngFromKey');

  /// Convert id to lat, lng, level
  var idToLatLng = S2.idToLatLng(idFromKey);
  print('idToLatLng: $idToLatLng');

  /// Get neighbors based on lat, lng, level
  var neighbors = S2.latLngToNeighborKeys(lat, lng, level);
  print('neighbors: $neighbors');
  
  ///  The next key of the current one
  var nextKey = S2.nextKey(key);
  print('nextKey: $nextKey');

  /// The previous key of the current one
  var prevKey = S2.prevKey(key);
  print('prevKey: $prevKey'); 
  
  /// step ten keys back 
  var backTenKeys = S2.stepKey(key, -10);
  print('backTenKeys: $backTenKeys'); 

}
```

    

