// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EmergencyAdminTest} from "./EmergencyAdmin.t.sol";
import {EmergencyAdmin} from "src/EmergencyAdmin.sol";

contract emergencyWithdrawTest is EmergencyAdminTest {
    function test_emergencyWithdraw_success() public {
        vm.prank(notAdmin);
        USDC.transfer(address(testInstance), 1000 * 1e6);

        // Test if you can withdraw less than the complete balance.
        uint256 balanceBefore = USDC.balanceOf(admin);
        vm.expectEmit();
        emit EmergencyAdmin.EmergencyWithdraw(address(USDC), admin, 100 * 1e6);
        vm.prank(admin);
        testInstance.emergencyWithdraw(address(USDC), 100 * 1e6, admin);
        assertEq(
            USDC.balanceOf(admin),
            balanceBefore + 100 * 1e6,
            "!withdraw partial balance"
        );

        // Test if you can withdraw the complete balance.
        balanceBefore = USDC.balanceOf(admin);
        vm.expectEmit();
        emit EmergencyAdmin.EmergencyWithdraw(address(USDC), admin, 900 * 1e6);
        vm.prank(admin);
        testInstance.emergencyWithdraw(address(USDC), 900 * 1e6, admin);
        assertEq(
            USDC.balanceOf(admin),
            balanceBefore + 900 * 1e6,
            "!withdraw full balance"
        );

        // Test if you can withdraw more than complete balance.
        // (Should empty the test contract.)
        vm.prank(notAdmin);
        USDC.transfer(address(testInstance), 1000 * 1e6);
        balanceBefore = USDC.balanceOf(admin);
        vm.expectEmit();
        emit EmergencyAdmin.EmergencyWithdraw(address(USDC), admin, 1000 * 1e6);
        vm.prank(admin);
        testInstance.emergencyWithdraw(address(USDC), type(uint256).max, admin);
        assertEq(
            USDC.balanceOf(admin),
            balanceBefore + 1000 * 1e6,
            "!withdraw more than full balance"
        );
    }
}
