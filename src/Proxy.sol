pragma solidity ^0.8.11;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Proxy is UUPSUpgradeable, Ownable {
    address public currentVersion;
    address[] public versionHistory;

    constructor(address initialOwner, address initialImplementation) Ownable(initialOwner) {
        currentVersion = initialImplementation;
        versionHistory.push(initialImplementation);
    }

    fallback() external payable {
        address implementation = currentVersion;
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

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
