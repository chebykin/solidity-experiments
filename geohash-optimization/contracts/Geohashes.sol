pragma solidity ^0.4.0;
pragma experimental "v0.5.0";

contract Geohashes {
  string public myString;
  bytes32 public myBytesInt;
  bytes32 public myBytesStr;
  uint256 public myInt;
  uint256 public converted;
  mapping(bytes2 => uint8) eMap;

  constructor() public {
    eMap["0"] = 0;
    eMap["1"] = 1;
    eMap["2"] = 2;
    eMap["3"] = 3;
    eMap["4"] = 4;
    eMap["5"] = 5;
    eMap["6"] = 6;
    eMap["7"] = 7;
    eMap["8"] = 8;
    eMap["9"] = 9;
    eMap["b"] = 10;
    eMap["c"] = 11;
    eMap["d"] = 12;
    eMap["e"] = 13;
    eMap["f"] = 14;
    eMap["g"] = 15;
    eMap["h"] = 16;
    eMap["j"] = 17;
    eMap["k"] = 18;
    eMap["m"] = 19;
    eMap["n"] = 20;
    eMap["p"] = 21;
    eMap["q"] = 22;
    eMap["r"] = 23;
    eMap["s"] = 24;
    eMap["t"] = 25;
    eMap["u"] = 26;
    eMap["v"] = 27;
    eMap["w"] = 28;
    eMap["x"] = 29;
    eMap["y"] = 30;
    eMap["z"] = 31;
  }

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

  function convertMap(bytes input) public returns (uint256) {
    // bytes memory input = "seze792kh375";
    uint256 output;
    uint8 counter;

    for (uint8 i = 0; i < input.length; i++) {
      output = output ^ eMap[input[i]];
      if (i + 1 != input.length) {
        // shift left 5 bits
        output = output * 2 ** 5;
      }

      counter = counter + 5;
    }

    converted = output;
  }

  /*
   * Symbols string: '0123456789bcdefghjkmnpqrstuvwxyz'
   */
  function convert(bytes input) public returns (uint256) {
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
        output = output ^ 10;
      } else if (input[i] == "c") {
        output = output ^ 11;
      } else if (input[i] == "d") {
        output = output ^ 12;
      } else if (input[i] == "e") {
        output = output ^ 13;
      } else if (input[i] == "f") {
        output = output ^ 14;
      } else if (input[i] == "g") {
        output = output ^ 15;
      } else if (input[i] == "h") {
        output = output ^ 16;
      } else if (input[i] == "j") {
        output = output ^ 17;
      } else if (input[i] == "k") {
        output = output ^ 18;
      } else if (input[i] == "m") {
        output = output ^ 19;
      } else if (input[i] == "n") {
        output = output ^ 20;
      } else if (input[i] == "p") {
        output = output ^ 21;
      } else if (input[i] == "q") {
        output = output ^ 22;
      } else if (input[i] == "r") {
        output = output ^ 23;
      } else if (input[i] == "s") {
        output = output ^ 24;
      } else if (input[i] == "t") {
        output = output ^ 25;
      } else if (input[i] == "u") {
        output = output ^ 26;
      } else if (input[i] == "v") {
        output = output ^ 27;
      } else if (input[i] == "w") {
        output = output ^ 28;
      } else if (input[i] == "x") {
        output = output ^ 29;
      } else if (input[i] == "y") {
        output = output ^ 30;
      } else if (input[i] == "z") {
        output = output ^ 31;
      }

      if (i + 1 != input.length) {
        // shift left 5 bits
        output = output * 2 ** 5;
      }

      counter = counter + 5;
    }

    converted = output;
  }
}