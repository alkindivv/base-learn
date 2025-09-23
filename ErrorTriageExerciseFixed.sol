// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    function diffWithNeighbor(
        uint _a, uint _b, uint _c, uint _d
    ) public pure returns (uint[] memory) {
        uint[] memory results = new uint[](3); // Declare and initialize array
        results[0] = _a >= _b ? _a - _b : _b - _a;
        results[1] = _b >= _c ? _b - _c : _c - _b;
        results[2] = _c >= _d ? _c - _d : _d - _c;
        return results;
    }

    function applyModifier(uint _base, int _modifier) public pure returns (uint) {
        int result = int(_base) + _modifier;
        require(result >= 0, "underflow");
        return uint(result);
    }

    uint[] arr;

    function popWithReturn() public returns (uint) {
        require(arr.length > 0, "empty");
        uint idx = arr.length - 1;
        uint val = arr[idx];
        arr.pop();
        return val;
    }

    // util
    function addToArr(uint _num) public { arr.push(_num); }
    function getArr() public view returns (uint[] memory) { return arr; }
    function resetArr() public { delete arr; }
}