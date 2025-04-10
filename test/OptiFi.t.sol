// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Test.sol";
import "../src/OptiFi.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error OwnableUnauthorizedAccount(address account);
error EnforcedPause();

contract OptiFiTest is Test {
    address public owner;

    function setUp() public {
        owner = address(this);
    }
}
