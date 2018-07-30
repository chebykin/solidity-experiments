pragma solidity 0.4.24;
pragma experimental "v0.5.0";

contract Proxy {
    // bytes32 constant version = 
    function getImpl() view public returns (address);

    function () payable external {
        address im = getImpl();
        assert(im != address(0));

        assembly {
            // TODO: load to mem from calldata
            let m := mload(0x40)
            calldatacopy(m, 0x0, calldatasize)

            let res := delegatecall(gas, im, m, calldatasize, 0x0, 0x0)
            let s := returndatasize
            returndatacopy(m, 0x0, s)

            switch res
            case 0 { revert(m, s) }
            default { return(m, s) }

        }
    }
}