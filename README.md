## Foundry

```bash
git clone https://github.com/optifi-edu/sc.git
cd sc/
```

### Build

```shell
$ forge build
```

```shell
$ forge script script/OptiFi.s.sol:DeployOptiFi --rpc-url open_campus --broadcast --verify --verifier https://edu-chain-testnet.blockscout.com/api/ --gas-limit 30000000 --with-gas-price 1gwei --skip-simulation
```

### Cast

```shell
$ cast <subcommand>
```