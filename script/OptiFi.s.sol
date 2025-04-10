// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../lib/forge-std/src/Script.sol";
import "../src/OptiFi.sol";
import "../src/MockEDU.sol";
import "../src/MockWEDU.sol";
import "../src/MockBlendFinance.sol"; // EDU
import "../src/MockSailFish.sol"; // WEDU
import "../src/MockCamelot.sol"; // EDU
import "../src/MockEdBank.sol"; // EDU
import "../src/MockMoveFlow.sol"; // WEDU

contract DeployOptiFi is Script {
    function run() external {
        // Deployment addresses for Uniswap V3 SwapRouter on Open Campus
        address routerAddress;

        if (block.chainid == 41923) {
            // Mainnet
            routerAddress = 0x2626664c2603336E57B271c5C0b26F421741e481;
        } else if (block.chainid == 656476) {
            // Testnet
            routerAddress = 0x94cC0AaC535CCDB3C01d6787D6413C739ae12bc4;
        } else {
            revert(
                "Unsupported network - Please use Mainnet or Testnet"
            );
        }

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy MockEDU
        MockEDU mockEDU = new MockEDU();
        console2.log("MockEDU deployed to:", address(mockEDU));

        // Deploy MockWEDU
        MockWEDU mockWEDU = new MockWEDU();
        console2.log("MockWEDU deployed to:", address(mockWEDU));

        // Deploy OptiFi
        OptiFi optiFi = new OptiFi(routerAddress);
        console2.log("OptiFi deployed to:", address(optiFi));

        uint256 initialSupply = 1_000_000_000_000_000_000_000_000 * 10 ** 6;

        // Mint & Transfer USDC
        mockEDU.mint(address(optiFi), initialSupply);

        // Mint & Transfer UNI
        mockWEDU.mint(address(optiFi), initialSupply);

        // Deploy MockBlendFinance with MockWEDU as staking token
        uint8 fixedAPY = 10; // 10% APY
        uint256 durationInDays = 3; // 3 day staking period
        uint256 maxAmountStaked = 100_000 * 10 ** 6; // 100,000 MockWEDU max stake

        MockBlendFinance mockBlendFinance = new MockBlendFinance(
            address(mockEDU),
            fixedAPY,
            durationInDays,
            maxAmountStaked
        );
        console2.log(
            "MockBlendFinance deployed to:",
            address(mockBlendFinance)
        );

        // Deploy MockSailFish with MockUSDT as staking token
        fixedAPY = 15; // 15% APY
        durationInDays = 7; // 7 day staking period
        maxAmountStaked = 100_000 * 10 ** 6; // 50,000 MockUSDT max stake

        MockSailFish mockSailFish = new MockSailFish(
            address(mockWEDU),
            fixedAPY,
            durationInDays,
            maxAmountStaked
        );
        console2.log(
            "MockSailFish deployed to:",
            address(mockSailFish)
        );

        // Deploy MockCamelot with MockDAI as staking token
        fixedAPY = 20; // 20% APY
        durationInDays = 14; // 14 day staking period
        maxAmountStaked = 100_000 * 10 ** 6; // 25,000 MockDAI max stake

        MockCamelot mockCamelot = new MockCamelot(
            address(mockEDU),
            fixedAPY,
            durationInDays,
            maxAmountStaked
        );
        console2.log(
            "MockCamelot deployed to:",
            address(mockCamelot)
        );

        // Deploy MockEdBank with MockWETH as staking token
        fixedAPY = 25; // 25% APY
        durationInDays = 30; // 30 day staking period
        maxAmountStaked = 100_000 * 10 ** 6; // 100,000 MockWETH max stake

        MockEdBank mockEdBank = new MockEdBank(
            address(mockEDU),
            fixedAPY,
            durationInDays,
            maxAmountStaked
        );
        console2.log(
            "MockEdBank deployed to:",
            address(mockEdBank)
        );

        // Deploy MockMoveFlow with MockEDU as staking token
        fixedAPY = 30; // 30% APY
        durationInDays = 60; // 60 day staking period
        maxAmountStaked = 100_000 * 10 ** 6; // 100,000 MockEDU max stake

        MockMoveFlow mockMoveFlow = new MockMoveFlow(
            address(mockEDU),
            fixedAPY,
            durationInDays,
            maxAmountStaked
        );
        console2.log("MockMoveFlow deployed to:", address(mockMoveFlow));

        vm.stopBroadcast();
    }
}
