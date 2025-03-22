pragma solidity ^0.8.11;

import {Test} from "forge-std/Test.sol";
import {vControl} from "../src/vControl.sol";
import {Proxy} from "../src/Proxy.sol";
import {BaseContract} from "../src/BaseContract.sol";
import {UpgradedContract} from "../src/UpgradedContract.sol";

contract vControlTest is Test {
    vControl system;
    BaseContract baseContract;
    UpgradedContract upgradedContract;

    address owner = address(0x123);

    function setUp() public {
        baseContract = new BaseContract();
        upgradedContract = new UpgradedContract();

        vm.prank(owner);
        system = new vControl(owner, address(baseContract));
    }

    function testInitialSetup() view public {
        assertEq(system.getCurrentVersion(), address(baseContract));
        address[] memory history = system.getVersionHistory();
        assertEq(history.length, 1);
        assertEq(history[0], address(baseContract));
    }

    function testUpgradeTo() public {
        vm.expectRevert();
        system.upgradeTo(address(upgradedContract));

        vm.prank(owner);
        system.upgradeTo(address(upgradedContract));
        
        assertEq(system.getCurrentVersion(), address(upgradedContract));
        
        address[] memory history = system.getVersionHistory();
        assertEq(history.length, 2);
        assertEq(history[1], address(upgradedContract));
    }

    function testRollbackTo() public {
        vm.prank(owner);
        system.upgradeTo(address(upgradedContract));

        vm.expectRevert();
        system.rollbackTo(0);
        
        vm.prank(owner);
        system.rollbackTo(0);
        
        assertEq(system.getCurrentVersion(), address(baseContract));
    }

    // check proxy functionality
    function testFunctionality() public {
        address proxyAddress = address(system.proxy());
        BaseContract baseViaProxy = BaseContract(proxyAddress);

        vm.prank(owner);
        baseViaProxy.setNumber(42);

        assertEq(baseViaProxy.getNumber(), 42);
        
        vm.prank(owner);
        system.upgradeTo(address(upgradedContract));
        
        UpgradedContract upgradedViaProxy = UpgradedContract(proxyAddress);

        assertEq(upgradedViaProxy.getNumber(), 42);
        
        vm.prank(owner);
        upgradedViaProxy.addNumber(10);

        assertEq(upgradedViaProxy.getNumber(), 52);
    }

   function testInvalidUpgrade() public {
        vm.prank(owner);
        vm.expectRevert("Invalid implementation address");
        system.upgradeTo(address(0));
    }

   function testInvalidRollback() public {
        vm.prank(owner);
        vm.expectRevert("Invalid version index");
        system.rollbackTo(999);
    }
}
