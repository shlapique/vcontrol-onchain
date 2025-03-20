pragma solidity ^0.8.11;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract vControl is UUPSUpgradeable, Ownable {
    address public currentVersion;
    address[] public versionHistory;

    constructor(address initialOwner) Ownable(initialOwner) {
        currentVersion = address(this);
    }

    function upgradeTo(address newImplementation) external onlyOwner {
        require(newImplementation != address(0), "Invalid address");
        require(newImplementation != currentVersion, "Same version");
        versionHistory.push(newImplementation);
        currentVersion = newImplementation;
        _upgradeTo(newImplementation);
    }

    function rollbackTo(uint256 versionIndex) external onlyOwner {
        require(versionIndex < versionHistory.length, "Invalid version");
        currentVersion = versionHistory[versionIndex];
        _upgradeTo(currentVersion);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}
