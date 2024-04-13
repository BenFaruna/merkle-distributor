// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2, stdJson} from "forge-std/Test.sol";

import {Merkle} from "../src/MerkleDrop.sol";

contract MerkleDropTest is Test {
    using stdJson for string;
    Merkle public merkle;
    struct Result {
        bytes32 leaf;
        bytes32[] proof;
    }

    struct User {
        address user;
        uint tokenId;
        uint amount;
    }
    Result public result;
    User public user;
    bytes32 root =
        0x7866e85b97067d0e25fcf2e73b13522300e92d10db0d8e828caa4b6aaf5e7e6f;
    address user1 = 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf;
    // address user499 = 0xc491904529E13E6A0aCdEF24036350b600397d88;
    // address user500 = 0x3447659E07332bb8D6E2E1985FB12e8fD6175645;

    function setUp() public {
        merkle = new Merkle(root);
        string memory _root = vm.projectRoot();
        string memory path = string.concat(_root, "/merkle_tree.json");

        string memory json = vm.readFile(path);
        string memory data = string.concat(_root, "/address_data.json");

        string memory dataJson = vm.readFile(data);

        bytes memory encodedResult = json.parseRaw(
            string.concat(".", vm.toString(user1))
        );
        user.user = vm.parseJsonAddress(
            dataJson,
            string.concat(".", vm.toString(user1), ".address")
        );
        user.tokenId = vm.parseJsonUint(
            dataJson,
            string.concat(".", vm.toString(user1), ".tokenId")
        );
        user.amount = vm.parseJsonUint(
            dataJson,
            string.concat(".", vm.toString(user1), ".amount")
        );
        result = abi.decode(encodedResult, (Result));
        console2.logBytes32(result.leaf);
    }

    function testClaimed() public {
        bool success = merkle.claim(
            user.user,
            user.tokenId,
            user.amount,
            result.proof
        );
        assertTrue(success);
    }

    function testAlreadyClaimed() public {
        merkle.claim(user.user, user.tokenId, user.amount, result.proof);
        vm.expectRevert("already claimed");
        merkle.claim(user.user, user.tokenId, user.amount, result.proof);
    }

    function testIncorrectProof() public {
        bytes32[] memory fakeProofleaveitleaveit;

        vm.expectRevert("not whitelisted");
        merkle.claim(
            user.user,
            user.tokenId,
            user.amount,
            fakeProofleaveitleaveit
        );
    }
}
