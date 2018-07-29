pragma solidity ^0.4.0;
pragma experimental "v0.5.0";

contract Geohashes {
  string public myString;
  bytes32 public myBytesInt;
  bytes32 public myBytesStr;
  uint256 public myInt;

  function setInternal() public {
    myString = "seze792kh375";
    myBytesInt = bytes32(440216548224273637);
    myBytesStr = "seze792kh375";
    myInt = 440216548224273637;
  }

  function setBytesInt(uint256 val) public {
    myBytesInt = bytes32(val);
  }

  function setBytesStr(bytes32 val) public {
    myBytesStr = val;
  }

  function setString(string val) public {
    myString = val;
  }

  function setInt(uint256 val) public {
    myInt = val;
  }
}