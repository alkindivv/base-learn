// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error TokensClaimed();
error AllTokensClaimed();
error UnsafeTransfer(address to);

contract UnburnableToken {
    mapping(address => uint) public balances;
    uint public totalSupply;
    uint public totalClaimed;

    mapping(address => bool) private claimed;

    constructor() {
        totalSupply = 100_000_000;
    }

    function claim() external {
        if (claimed[msg.sender]) revert TokensClaimed();
        if (totalClaimed + 1000 > totalSupply) revert AllTokensClaimed();
        claimed[msg.sender] = true;
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
    }

    function safeTransfer(address _to, uint _amount) external {
        if (_to == address(0) || _to.balance == 0) revert UnsafeTransfer(_to);
        require(balances[msg.sender] >= _amount, "insufficient");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}