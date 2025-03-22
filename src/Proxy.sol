pragma solidity ^0.8.11;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract Proxy is UUPSUpgradeable, Ownable {
    address public currentImplementation;
    address[] public versionHistory;
    address public immutable vControlContract;

    bool private initialized = false;

    constructor(address vControlAddr) Ownable(vControlAddr) {
        vControlContract = vControlAddr;
    }

    function initializeImplementation(address newImplementation) external {
        require(msg.sender == vControlContract, "Only vControl can initialize");
        require(!initialized, "Already initialized");
        require(newImplementation != address(0), "Invalid implementation address");
        
        versionHistory.push(newImplementation);
        currentImplementation = newImplementation;
        ERC1967Utils.upgradeToAndCall(newImplementation, "");
        initialized = true;
    }

    function upgradeTo(address newImplementation) external {
        require(msg.sender == vControlContract, "Only vControl can upgrade");
        require(newImplementation != address(0), "Invalid implementation address");
        require(newImplementation != currentImplementation, "Same implementation");
        
        versionHistory.push(newImplementation);
        currentImplementation = newImplementation;
        ERC1967Utils.upgradeToAndCall(newImplementation, "");
    }

    function rollbackTo(uint256 versionIndex) external {
        require(msg.sender == vControlContract, "Only vControl can rollback");
        require(versionIndex < versionHistory.length, "Invalid version index");
        
        address previousImplementation = versionHistory[versionIndex];
        currentImplementation = previousImplementation;
        ERC1967Utils.upgradeToAndCall(previousImplementation, "");
    }

    fallback() external payable {
        address implementation = currentImplementation;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function getCurrentVersion() external view returns (address) {
        return currentImplementation;
    }

    function getVersionHistory() external view returns (address[] memory) {
        return versionHistory;
    }
}
