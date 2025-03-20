pragma solidity ^0.8.11;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Proxy} from "../src/Proxy.sol";
import {vControl} from "../src/vControl.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        vControl ver1 = new vControl();
        Proxy proxy = new Proxy();
        proxy.initialize(address(ver1));
        vm.stopBroadcast();
    }
}
