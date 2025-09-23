// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error NotApproved(string album);

contract FavoriteRecords {
    mapping(string => bool) public approvedRecords;
    string[] private approvedList;

    mapping(address => mapping(string => bool)) public userFavorites;
    mapping(address => string[]) private userFavList;

    constructor() {
        string[9] memory seed = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];
        for (uint i = 0; i < seed.length; i++) {
            approvedRecords[seed[i]] = true;
            approvedList.push(seed[i]);
        }
    }

    function getApprovedRecords() external view returns (string[] memory) {
        return approvedList;
    }

    function addRecord(string calldata album) external {
        if (!approvedRecords[album]) revert NotApproved(album);
        if (!userFavorites[msg.sender][album]) {
            userFavorites[msg.sender][album] = true;
            userFavList[msg.sender].push(album);
        }
    }

    function getUserFavorites(address user) external view returns (string[] memory) {
        return userFavList[user];
    }

    function resetUserFavorites() external {
        delete userFavList[msg.sender];
    }
}