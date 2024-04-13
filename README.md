# Merkle distributor

This uses a merkle tree to distribute ERC1155 rewards to addresses. A `data.csv` file containing the `address`, `tokenId` and `amount` column is parsed to generate a Merkle tree and proof. The `MerkleDrop` contract serves as the distributor and ERC1155 contract. This is a minimal implementation of the concept that utilizes merkle trees to distribute token rewards to qualified addresses.


## Prerequisite
- Node, Python, foundry

## Setup
- Install the node packages
```
$ npm i
```

For testing purposes, you can generate synthetic data.

- Create `./scripts/address.csv` file using the command
```
$ forge scripts ./scripts/CreateAddress.s.sol
```

- Generate synthentic data using the command
```
$ python ./scripts/generateData.py
```

- Create merkle tree using the command
```
$ npx hardhat run ./scripts/generateTree.ts
```

- Copy the merkle root and edit the `./test/MerkleDrop.t.sol` and change the `root` variable to the root you copied from your terminal.

- Run test with the command
```
$ forge t
```