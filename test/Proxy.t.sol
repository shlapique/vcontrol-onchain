pragma solidity ^0.8.11;

import {Test} from "forge-std/Test.sol";
import {Proxy} from "../src/Proxy.sol";
import {vControl} from "../src/vControl.sol";

contract ProxyTest is Test {
    Proxy proxy;
    vControl ver1;
    vControl ver2;

    function setUp() public {
        ver1 = new vControl();
        ver2 = new vControl();
        proxy = new Proxy();
        proxy.initialize(address(ver1));
    }

    function testUpgrade() public {
        vm.prank(proxy.owner());
        proxy.upgradeTo(address(ver2));
        assertEq(proxy.currentVersion(), address(ver2));
        assertEq(proxy.versionHistory(1), address(ver2));
    }

    function testRollback() public {
        vm.startPrank(proxy.owner());
        proxy.upgradeTo(address(ver2));
        proxy.rollbackTo(0);
        assertEq(proxy.currentVersion(), address(ver1));
        vm.stopPrank();
    }
}
