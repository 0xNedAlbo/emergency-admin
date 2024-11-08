// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EmergencyAdminTest} from "./EmergencyAdmin.t.sol";
import {EmergencyAdmin} from "src/EmergencyAdmin.sol";

contract onlyEmergencyAdminTest is EmergencyAdminTest {
    function test_emergencyCall_reverts_withNotAdmin() public {
        bytes memory data = new bytes(0x0);
        vm.prank(notAdmin);
        vm.expectRevert(EmergencyAdmin.OnlyEmergencyAdmin.selector);
        testInstance.emergencyCall(address(0x0), data);
    }

    function test_emergencyWithdraw_reverts_withNotAdmin() public {
        vm.prank(notAdmin);
        vm.expectRevert(EmergencyAdmin.OnlyEmergencyAdmin.selector);
        testInstance.emergencyWithdraw(address(USDC), 1000, notAdmin);
    }

    function test_emergencyWithdrawEth_reverts_withNotAdmin() public {
        vm.prank(notAdmin);
        vm.expectRevert(EmergencyAdmin.OnlyEmergencyAdmin.selector);
        testInstance.emergencyWithdrawEth(1000, notAdmin);
    }

    function test_setEmergencyAdmin_reverts_withNotAdmin() public {
        vm.prank(notAdmin);
        vm.expectRevert(EmergencyAdmin.OnlyEmergencyAdmin.selector);
        testInstance.setEmergencyAdmin(admin);
    }

    function test_disableEmergencyAdmin_reverts_withNotAdmin() public {
        vm.prank(notAdmin);
        vm.expectRevert(EmergencyAdmin.OnlyEmergencyAdmin.selector);
        testInstance.disableEmergencyAdmin();
    }
}
