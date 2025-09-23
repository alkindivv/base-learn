// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error AfterHours(uint time);

contract ControlStructuresExercise {
    function fizzBuzz(uint _number) external pure returns (string memory) {
        bool f = _number % 3 == 0;
        bool b = _number % 5 == 0;
        if (f && b) return "FizzBuzz";
        if (f) return "Fizz";
        if (b) return "Buzz";
        return "Splat";
    }

    function doNotDisturb(uint _time) external pure returns (string memory) {
        if (_time >= 2400) {
            assert(false); // trigger Panic
        }
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }
        if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }
        if (_time <= 1159) return "Morning!";
        if (_time <= 1759) return "Afternoon!";
        return "Evening!";
    }
}