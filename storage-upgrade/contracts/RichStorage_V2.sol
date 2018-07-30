pragma solidity 0.4.24;
pragma experimental "v0.5.0";

import "./UpgradeabilityProxy.sol";
import "./RichStorage_V1.sol";

contract RichStorage_V2 is RichStorage_V1 {
    uint256 secondLevelUint;

    function resetUint() public {
        myUint = 3;
    }

    function justGet() pure public returns (uint) {
        return 42;
    }

    function initialize() public {
        secondLevelUint = 123;
    }
}
