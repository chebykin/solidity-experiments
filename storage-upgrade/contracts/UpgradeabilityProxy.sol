pragma solidity 0.4.24;
pragma experimental "v0.5.0";

import "./Proxy.sol";

contract UpgradeabilityProxy is Proxy {
    // bytes32 private constant implPosition = keccak256("org.chebykin.solidity-experiments.upgradable-proxy");
    event Upgraded(address sender, address oldVersion, address newVersion);
    address public impl;

    constructor() public {}

    function upgrade(address newVersion) public {
        address _impl = getImpl();
        impl = newVersion;
        emit Upgraded(msg.sender, _impl, impl);
    }

    function getImpl() view public returns (address) {
        return impl;
    }
}