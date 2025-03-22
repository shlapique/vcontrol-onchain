pragma solidity ^0.8.11;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BaseContract} from "../src/BaseContract.sol";
import {vControl} from "../src/vControl.sol";

contract DeployScript is Script {
    function run() external {
        address owner = vm.envAddress("OWNER_ADDRESS");
        console.log("OWNER_ADDRESS:", owner);
        vm.startBroadcast();
        BaseContract baseContract = new BaseContract();
        vControl versionManager = new vControl(owner, address(baseContract));
        vm.stopBroadcast();

        console.log("BaseContract deployed at:", address(baseContract));
        console.log("vControl deployed at:", address(versionManager));
    }
}
