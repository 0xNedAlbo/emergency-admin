// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EmergencyAdminTest} from "./EmergencyAdmin.t.sol";
import {EmergencyAdmin} from "src/EmergencyAdmin.sol";

contract disableEmergencyAdminTest is EmergencyAdminTest {
    function test_disableEmergencyAdmin_success() public {
        vm.expectEmit();
        emit EmergencyAdmin.SetEmergencyAdmin(address(0x0));
        vm.startPrank(admin);
        testInstance.disableEmergencyAdmin();
        assertEq(
            testInstance.emergencyAdmin(),
            address(0x0),
            "admin was not set to zero address"
        );
        bytes memory data = new bytes(0x0);
        vm.expectRevert(EmergencyAdmin.EmergencyAdminDisabled.selector);
        testInstance.emergencyCall(address(0x0), data);
        vm.expectRevert(EmergencyAdmin.EmergencyAdminDisabled.selector);
        testInstance.emergencyWithdraw(address(USDC), 1000, admin);
        vm.expectRevert(EmergencyAdmin.EmergencyAdminDisabled.selector);
        testInstance.emergencyWithdrawEth(1000, admin);
        vm.expectRevert(EmergencyAdmin.EmergencyAdminDisabled.selector);
        testInstance.setEmergencyAdmin(notAdmin);
        vm.stopPrank();
    }
}
