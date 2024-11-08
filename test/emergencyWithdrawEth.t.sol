// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EmergencyAdminTest} from "./EmergencyAdmin.t.sol";
import {EmergencyAdmin} from "src/EmergencyAdmin.sol";

contract emergencyWithdrawTest is EmergencyAdminTest {
    function test_emergencyWithdrawEth_success() public {
        deal(address(testInstance), 100 ether);

        // Test if you can withdraw less than the complete balance.
        uint256 balanceBefore = admin.balance;
        vm.expectEmit();
        emit EmergencyAdmin.EmergencyWithdraw(address(0x0), admin, 10 ether);
        vm.prank(admin);
        testInstance.emergencyWithdrawEth(10 ether, admin);
        assertEq(
            admin.balance,
            balanceBefore + 10 ether,
            "!withdraw partial balance"
        );

        // Test if you can withdraw the complete balance.
        balanceBefore = admin.balance;
        vm.expectEmit();
        emit EmergencyAdmin.EmergencyWithdraw(address(0x0), admin, 90 ether);
        vm.prank(admin);
        testInstance.emergencyWithdrawEth(90 ether, admin);
        assertEq(
            admin.balance,
            balanceBefore + 90 ether,
            "!withdraw full balance"
        );

        // Test if you can withdraw more than complete balance.
        // (Should empty the test contract.)
        deal(address(testInstance), 100 ether);
        balanceBefore = admin.balance;
        vm.expectEmit();
        emit EmergencyAdmin.EmergencyWithdraw(address(0x0), admin, 100 ether);
        vm.prank(admin);
        testInstance.emergencyWithdrawEth(type(uint256).max, admin);
        assertEq(
            admin.balance,
            balanceBefore + 100 ether,
            "!withdraw more than full balance"
        );
    }
}
