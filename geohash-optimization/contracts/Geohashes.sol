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


  function convert() view public returns (uint256) {
      // bytes32 input = "seze792kh375";
    bytes memory input = "1234567c";
    uint256 output;
    uint8 counter;

    for (uint8 i = 0; i < input.length; i++) {
      if (input[i] == "0") {
        output = output ^ 0;
      } else if (input[i] == "1") {
        output = output ^ 1;
      } else if (input[i] == "2") {
        output = output ^ 2;
      } else if (input[i] == "3") {
        output = output ^ 3;
      } else if (input[i] == "4") {
        output = output ^ 4;
      } else if (input[i] == "5") {
        output = output ^ 5;
      } else if (input[i] == "6") {
        output = output ^ 6;
      } else if (input[i] == "7") {
        output = output ^ 7;
      } else if (input[i] == "8") {
        output = output ^ 8;
      } else if (input[i] == "9") {
        output = output ^ 9;
      } else if (input[i] == "b") {
        output = output ^ 11;
      } else if (input[i] == "c") {
        output = output ^ 12;
      }

      if (i + 1 != input.length) {
        // shift left 5 bits
        output = output * 2 ** 5;
      }

      counter = counter + 5;
    }

    return output;
  }
}