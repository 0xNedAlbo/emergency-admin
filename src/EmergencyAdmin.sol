// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EmergencyAdmin {
    address public emergencyAdmin;

    error OnlyEmergencyAdmin();
    error EmergencyAdminDisabled();

    event SetEmergencyAdmin(address indexed newEmergencyAdmin);
    event EmergencyWithdraw(
        address indexed token,
        address indexed receiver,
        uint256 amountTransferred
    );
    event EmergencyCall(
        address indexed target,
        bool success,
        bytes data,
        bytes result
    );

    modifier onlyEmergencyAdmin() {
        if (emergencyAdmin == address(0x0)) revert EmergencyAdminDisabled();
        if (msg.sender != emergencyAdmin) revert OnlyEmergencyAdmin();
        _;
    }

    constructor(address initialEmergencyAdmin) {
        emergencyAdmin = initialEmergencyAdmin;
    }

    function setEmergencyAdmin(address newAdmin) public onlyEmergencyAdmin {
        require(newAdmin != address(0x0), "zero address");
        emergencyAdmin = newAdmin;
        emit SetEmergencyAdmin(newAdmin);
    }

    function emergencyCall(
        address target,
        bytes memory data
    )
        public
        payable
        onlyEmergencyAdmin
        returns (bool success, bytes memory result)
    {
        require(target.code.length > 0, "Target must be a contract");
        (success, result) = target.call{value: msg.value}(data);
        emit EmergencyCall(target, success, data, result);
    }

    function emergencyWithdraw(
        address token,
        uint256 amount,
        address receiver
    ) public onlyEmergencyAdmin returns (uint256) {
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (amount > balance) amount = balance;
        if (amount == 0) return 0;
        IERC20(token).transfer(receiver, amount);
        emit EmergencyWithdraw(token, receiver, amount);
        return amount;
    }

    function emergencyWithdrawEth(
        uint256 amount,
        address payable receiver
    ) public onlyEmergencyAdmin returns (uint256) {
        uint256 balance = address(this).balance;
        if (amount > balance) amount = balance;
        if (amount == 0) return 0;
        receiver.transfer(amount);
        emit EmergencyWithdraw(address(0x0), receiver, amount);
        return amount;
    }

    function disableEmergencyAdmin() public onlyEmergencyAdmin {
        emergencyAdmin = address(0x0);
        emit SetEmergencyAdmin(address(0x0));
    }
}
