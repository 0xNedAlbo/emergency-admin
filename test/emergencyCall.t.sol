// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EmergencyAdminTest} from "./EmergencyAdmin.t.sol";
import {EmergencyAdmin} from "src/EmergencyAdmin.sol";

contract CallTarget {
    uint256 public data;
    address public caller;
    bool public wasCalled;

    constructor() {
        data = 0;
        caller = address(0x0);
        wasCalled = false;
    }

    function testCallSuccess(uint256 testData) public returns (uint256) {
        data = testData;
        wasCalled = true;
        caller = msg.sender;
        return testData;
    }

    function testCallFailure(uint256) public pure returns (uint256) {
        revert("failed");
    }
}

contract emergencyCallTest is EmergencyAdminTest {
    function test_emergencyCall_success() public {
        CallTarget target = new CallTarget();

        bytes memory testData = abi.encodeWithSelector(
            CallTarget.testCallSuccess.selector,
            256
        );
        vm.prank(admin);
        (bool success, bytes memory returnData) = testInstance.emergencyCall(
            address(target),
            testData
        );
        assertTrue(success, "did not return 'success=true'");
        assertEq(abi.decode(returnData, (uint256)), 256, "wrong return data");
        assertTrue(target.wasCalled(), "target not called");
        assertEq(target.data(), 256, "target data not set");
        assertEq(
            target.caller(),
            address(testInstance),
            "target not called by test instance"
        );
    }

    function test_emergencyCall_failed() public {
        CallTarget target = new CallTarget();

        bytes memory testData = abi.encodeWithSelector(
            CallTarget.testCallFailure.selector,
            256
        );
        vm.prank(admin);
        (bool success, bytes memory returnData) = testInstance.emergencyCall(
            address(target),
            testData
        );
        emit log_bytes(returnData);
        assertTrue(!success, "did not return 'success=false'");
        assertTrue(!target.wasCalled(), "target was called");
        assertTrue(target.data() != 256, "target data was set");
        assertEq(
            target.caller(),
            address(0x0),
            "target was called by test instance"
        );
    }
}
