// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;



// Constructor Parameters:
// 	•	`_shares`: 1000
// 	•	`_name`: “Pat”
// 	•	`_salary`: 50000
// 	•	`_idNumber`: 112358132134




contract EmployeeStorage {
    // ✅ STORAGE OPTIMIZATION: Pack shares + salary in one slot
    uint16 private shares;   // Max 5000 shares fits in uint16 (2 bytes)
    uint32 private salary;   // Max 1,000,000 salary fits in uint32 (4 bytes)
    // Total: 6 bytes packed in one 32-byte slot
    
    // Public variables (separate slots)
    string public name;      // Dynamic storage
    uint256 public idNumber; // Full uint256 for any number up to 2^256-1
    
    // Custom error
    error TooManyShares(uint256 expectedShares);
    
    constructor(uint16 _shares, string memory _name, uint32 _salary, uint256 _idNumber) {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }
    
    // View salary function
    function viewSalary() public view returns (uint32) {
        return salary;
    }
    
    // View shares function  
    function viewShares() public view returns (uint16) {
        return shares;
    }
    
    // Grant shares function with validation
    function grantShares(uint16 _newShares) public {
        // Check if _newShares itself is > 5000
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        
        // Check if total would exceed 5000
        uint256 newTotalShares = uint256(shares) + _newShares;
        if (newTotalShares > 5000) {
            revert TooManyShares(newTotalShares);
        }
        
        shares += _newShares;
    }
    
    /**
    * Do not modify this function. It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by your wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }
    
    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }
}
