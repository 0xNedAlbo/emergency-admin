// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BaseTest} from "./BaseTest.sol";
import {MockERC20} from "@mock-tokens/src/MockERC20.sol";

import {EmergencyAdmin} from "src/EmergencyAdmin.sol";

contract EmergencyAdminTest is BaseTest {
    address payable public admin;
    address payable public notAdmin;

    MockERC20 public USDC;

    EmergencyAdmin testInstance;

    function setUp() public virtual override {
        BaseTest.setUp();
        testInstance = new EmergencyAdmin(admin);
    }

    function setUp_fork() public virtual override {}

    function setUp_users() public virtual override {
        admin = payable(vm.addr(0x1));
        notAdmin = payable(vm.addr(0x2));
        vm.label(admin, "admin");
        vm.label(notAdmin, "notAdmin");

        deal(admin, 1000 ether);
        deal(notAdmin, 1000 ether);

        USDC.mint(admin, 100000 * 1e6);
        USDC.mint(notAdmin, 100000 * 1e6);
    }

    function setUp_tokens() public virtual override {
        USDC = new MockERC20("USDC Stablecoin", "USDC", 6);
    }
}
