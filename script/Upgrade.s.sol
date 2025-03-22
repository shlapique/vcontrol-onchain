pragma solidity ^0.8.11;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {UpgradedContract} from "../src/UpgradedContract.sol";
import {vControl} from "../src/vControl.sol";

contract UpgradeScript is Script {
    function run(address vControlAddress) external {
        console.log("Got vControl Address from user:", vControlAddress, " !");
        vm.startBroadcast();
        console.log("Trying to deploy UpgradedContract...");
        UpgradedContract upgradedContract = new UpgradedContract();
        console.log("UpgradedContract deployed at:", address(upgradedContract));
        
        console.log("Upgradging system: BaseContract -> UpgradedContract ...");
        vControl versionManager = vControl(vControlAddress);
        versionManager.upgradeTo(address(upgradedContract));
        vm.stopBroadcast();
        console.log("Done.");
    }
}
