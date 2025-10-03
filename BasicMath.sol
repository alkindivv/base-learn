// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BasicMath {
    function adder(uint _a, uint _b) external pure returns (uint sum, bool error) {
        unchecked {
            uint s = _a + _b;
            if (s < _a) {
                // overflow terjadi
                return (0, true);
            }
            return (s, false);
        }
    }

    // Mengurangkan dua uint.
    // Mengembalikan (difference, error) sesuai spesifikasi.
    function subtractor(uint _a, uint _b) external pure returns (uint difference, bool error) {
        if (_b > _a) {
            // underflow terjadi
            return (0, true);
        }
        unchecked {
            return (_a - _b, false);
        }
    }
}
