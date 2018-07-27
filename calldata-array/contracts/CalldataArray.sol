pragma solidity 0.4.24;
pragma experimental "v0.5.0";


contract CalldataArray{
    uint[] public myAry;
    event Received(uint length);
    uint public iterator;

    constructor() public {
    }

    function acceptArray(uint[] values) public {
        for (uint16 i = 0; i < values.length; i++) {
            myAry.push(values[i]);
        }
        emit Received(values.length);
    }

    function empty() public {
        for (uint i = 0; i < myAry.length; i++) {
            myAry[i] = 0;
        }
        myAry.length = 0;
    }
}
