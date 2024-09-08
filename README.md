# s2geometry_dart

- This project is to port JavaScript version of S2 Geometry Library to Dart, the porting task is based on the script from  https://www.npmjs.com/package/s2-geometry as a reference.
- The goal of this porting task is to retain all functionality in the reference, but split the main script into multiple scripts for enhancing code maintainability and improve testability, and improve user experience so that users can use the package more intuitively and easily.

## Reference

https://www.npmjs.com/package/s2-geometry (javascript)  
https://github.com/google/s2geometry (python)   
https://github.com/google/s2-geometry-library-java (java)  
https://github.com/nbspou/dart-s2geometry (dart)

## Porting plan

1. Target: 
    - functional completeness: Dart version should be able to implement all the functions in JavaScript version
    - testing coverage: Make sure test cases in Dart version have a comparable coverage rate to JavaScript version
    - convenience of use: Improve the convenience of use and ensure that users can use the package easily without a deep understanding of the internal implementation.

2. Preparation and analysis: 
    - due to that all function on Javascript version was combined as one script, so the script was split into several functions to improve maintainability.
    - code test cases for each function to ensure the availability of each function through testing.
    - analyze the structure of all module.

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

- differences of language feature: Javascript is a dynamic typing language and Dart is a static typing, so need to check and reconstruct the type of each variable and function.

- data structure: 'Array' and 'Object' are the most commonly used in JavaScript, 'List' and 'Map' have different ways of use in Dart, so the code needs to be rewritten to accommodate the methods and features of Dart

- use 'BigInt' to declare S2 cell id for solving the problem of a number over 64 bits.

## Usage

- clone the package in your project

```sh
git clone https://github.com/h102136/s2geometry_dart
```
```
your_project/
├── lib/
└── s2geometry_dart/
```
- add the dependency in 'pubspec.yaml'

```yaml
dependencies:
    s2geometry_dart:
    path: s2geometry_dart
```
## Example
```dart
import 'package:s2geometry_dart/s2geometry.dart';

void main(){

  // Define latitude, longitude and level
  var lat = 40.2574448;
  var lng = -111.7089464;
  var level = 15;
  
  // Convert lat and lng to key 
  var key = S2.latLngToKey(lat, lng, level);
  print(key);

  // Convert key to s2cell id 
  var idFromKey = S2.keyToId(key);
  print(idFromKey);

  var keyFromId = S2.idToKey(idFromKey);
  print(keyFromId);

  //Get neighbors based on lat, lng, level
  var neighbors = S2.latLngToNeighborKeys(lat, lng, level);
  print(neighbors);
  
  //The next key of the current one
  var nextKey = S2.nextKey(key);
  print(nextKey);
  //The previous key of the current one
  var prevKey = S2.prevKey(key);
  print(prevKey); 
  
  //step ten keys back 
  var backTenKeys = S2.stepKey(key, -10);
  print(backTenKeys); 

}
```

    

