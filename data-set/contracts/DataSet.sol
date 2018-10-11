pragma solidity ^0.4.25;
pragma experimental "v0.5.0";

contract DataSet {
  bytes32[] array;

  mapping(bytes32 => uint256) map;
  mapping(bytes32 => bool) exists;

  function add(bytes32 _v) external {
    require(exists[_v] == false, "Element already exists");

    map[_v] = array.length;
    exists[_v] = true;
    array.push(_v);
  }

  function remove(bytes32 _v) external {
    require(array.length > 0, "Array is empty");
    require(exists[_v] == true, "Element doesn't exist");

    uint256 lastElementIndex = array.length - 1;
    uint256 currentElementIndex = map[_v];
    bytes32 lastElement = array[lastElementIndex];

    array[currentElementIndex] = lastElement;
    delete array[lastElementIndex];

    array.length = array.length - 1;
    delete map[_v];
    delete exists[_v];
    map[lastElement] = currentElementIndex;
  }

  function elements() external view returns (bytes32[]) {
    return array;
  }

  function length() external view returns (uint256) {
    return array.length;
  }
}
