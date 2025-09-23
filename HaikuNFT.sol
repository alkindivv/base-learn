// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

error HaikuNotUnique();
error NotYourHaiku(uint id);
error NoHaikusShared();

contract HaikuNFT is ERC721 {
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    // index 0 tidak dipakai
    Haiku[] public haikus;
    uint public counter = 1;

    // wallet => list id haiku yang dishare ke wallet itu
    mapping(address => uint[]) public sharedHaikus;

    // cek keunikan setiap baris
    mapping(bytes32 => bool) private usedLineHash;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
        haikus.push(Haiku(address(0), "", "", "")); // pad index 0
    }

    function mintHaiku(string calldata l1, string calldata l2, string calldata l3) external {
        if (usedLineHash[keccak256(bytes(l1))]) revert HaikuNotUnique();
        if (usedLineHash[keccak256(bytes(l2))]) revert HaikuNotUnique();
        if (usedLineHash[keccak256(bytes(l3))]) revert HaikuNotUnique();

        usedLineHash[keccak256(bytes(l1))] = true;
        usedLineHash[keccak256(bytes(l2))] = true;
        usedLineHash[keccak256(bytes(l3))] = true;

        uint id = counter;
        _safeMint(msg.sender, id);
        haikus.push(Haiku(msg.sender, l1, l2, l3));
        counter = id + 1;
    }

    function shareHaiku(address _to, uint id) public {
        if (ownerOf(id) != msg.sender) revert NotYourHaiku(id);
        sharedHaikus[_to].push(id);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint[] storage ids = sharedHaikus[msg.sender];
        if (ids.length == 0) revert NoHaikusShared();
        Haiku[] memory list = new Haiku[](ids.length);
        for (uint i = 0; i < ids.length; i++) {
            list[i] = haikus[ids[i]];
        }
        return list;
    }
}