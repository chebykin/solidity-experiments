pragma solidity 0.4.24;
pragma experimental "v0.5.0";

contract RichStorage_V1 {
    mapping(bytes32 => uint) public uints;
    bytes32 internal initialized;
    uint256 public myUint;
    bytes32 public myBytes;
    mapping(address => uint) public myMap;
    constructor() public {
    }

    event Initialize(bytes32 initAddress);

    function initialize() public {
        emit Initialize(initialized);
        // require(initialized == 0x0);

        myUint = 42;
        myBytes = "blah";
        myMap[0x13] = 123;

        // initialized = 0x1;
    }
}
