pragma solidity ^0.8.11;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Proxy} from "./Proxy.sol";
import {IERC1822Proxiable} from "@openzeppelin/contracts/interfaces/draft-IERC1822.sol";

contract vControl is UUPSUpgradeable, Ownable {
    Proxy public proxy;

    constructor(address owner, address initialImplementation) Ownable(owner) {
        proxy = new Proxy(address(this));
        _initializeProxy(initialImplementation);
    }

    function _initializeProxy(address initialImplementation) internal {
        proxy.initializeImplementation(initialImplementation);
    }

    function upgradeTo(address newImplementation) external onlyOwner {
        require(newImplementation != address(0), "Invalid implementation address");
        proxy.upgradeTo(newImplementation);
    }

    function rollbackTo(uint256 versionIndex) external onlyOwner {
        require(versionIndex < proxy.getVersionHistory().length, "Invalid version index");
        proxy.rollbackTo(versionIndex);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function getCurrentVersion() external view returns (address) {
        return proxy.getCurrentVersion();
    }

    function getVersionHistory() external view returns (address[] memory) {
        return proxy.getVersionHistory();
    }
}
