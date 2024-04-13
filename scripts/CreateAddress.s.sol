// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

contract CreateData is Script {
    function setUp() public {}

    function run() public {
        for (uint256 i = 1; i <= 500; i++) {
            address addr = vm.addr(i);
            vm.writeLine("address.csv", vm.toString(addr));
        }
    }
}
