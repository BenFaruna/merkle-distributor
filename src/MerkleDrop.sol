// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "solmate/utils/MerkleProofLib.sol";
import "solmate/tokens/ERC1155.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Merkle is ERC1155 {
    bytes32 root;

    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant DIAMOND = 2;
    uint256 public constant PLATINUM = 3;

    // "https://nothingness.com/{id}.json"
    constructor(bytes32 _root) ERC1155() {
        root = _root;
    }

    mapping(address => bool) public hasClaimed;

    function claim(
        address _claimer,
        uint _tokenId,
        uint _amount,
        bytes32[] calldata _proof
    ) external returns (bool success) {
        require(!hasClaimed[_claimer], "already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(_claimer, _tokenId, _amount));
        bool verificationStatus = MerkleProofLib.verify(_proof, root, leaf);
        require(verificationStatus, "not whitelisted");
        hasClaimed[_claimer] = true;
        _mint(_claimer, _tokenId, _amount, "");
        success = true;
    }

    function uri(uint256 id) public pure override returns (string memory) {
        return
            string(abi.encodePacked("https://nothingness.com/", id, ".json"));
    }
}
