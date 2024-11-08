// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EmergencyAdminTest} from "./EmergencyAdmin.t.sol";
import {EmergencyAdmin} from "src/EmergencyAdmin.sol";

contract setEmergencyAdminTest is EmergencyAdminTest {
    function test_setEmergencyAdmin_success() public {
        vm.expectEmit();
        emit EmergencyAdmin.SetEmergencyAdmin(notAdmin);
        vm.prank(admin);
        testInstance.setEmergencyAdmin(notAdmin);
        assertEq(
            testInstance.emergencyAdmin(),
            notAdmin,
            "admin was not set correctly"
        );
    }

    function test_setEmergencyAdmin_reverts_withZeroAddress() public {
        vm.prank(admin);
        vm.expectRevert("zero address");
        testInstance.setEmergencyAdmin(address(0x0));
    }
}
