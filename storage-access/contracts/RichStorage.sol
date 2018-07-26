pragma solidity 0.4.24;
pragma experimental "v0.5.0";


contract RichStorage {
    uint256 public myUint;
    bytes32 public myBytes;
    mapping(address => uint) public myMap;
    address[] myAry;

    constructor() public {
        myUint = 42;
        myBytes = "blah";
        myMap[0x13] = 123;
        myAry.push(44);
        myAry.push(45);
        myAry.push(46);
    }
}
