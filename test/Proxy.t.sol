pragma solidity ^0.8.11;

import {Test} from "forge-std/Test.sol";
import {vControl} from "../src/vControl.sol";
import {BaseContract} from "../src/BaseContract.sol";
import {UpgradedContract} from "../src/UpgradedContract.sol";

contract ProxyTest is Test {
    vControl system;
    BaseContract baseContract;
    UpgradedContract upgradedContract;

    address owner = address(0x123);

    function setUp() public {
        baseContract = new BaseContract();

        vm.prank(owner);
        system = new vControl(owner, address(baseContract));

        upgradedContract = new UpgradedContract();
    }

    function testUpgrade() public {
        vm.prank(owner);
        system.upgradeTo(address(upgradedContract));
        assertEq(system.getCurrentVersion(), address(upgradedContract));
    }

    function testRollback() public {
        vm.prank(owner);
        system.upgradeTo(address(upgradedContract));

        vm.prank(owner);
        system.rollbackTo(0);

        assertEq(system.getCurrentVersion(), address(baseContract));
    }
}
