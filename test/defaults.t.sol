// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EmergencyAdminTest} from "./EmergencyAdmin.t.sol";
import {EmergencyAdmin} from "src/EmergencyAdmin.sol";

contract contractDefaultsTest is EmergencyAdminTest {
    function test_emergencyAdmin() public view {
        assertEq(
            testInstance.emergencyAdmin(),
            admin,
            "default admin is not setup"
        );
    }

    function test_isEnabled() public view {
        assertTrue(
            testInstance.emergencyAdmin() != address(0x0),
            "emergency admin is disabled"
        );
    }
}
