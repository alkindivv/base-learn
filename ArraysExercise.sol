// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

contract ArraysExercise {
    // Starter array 1..10
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];

    // Untuk bagian timestamp
    address[] public senders;
    uint[] public timestamps;

    // Return seluruh isi "numbers"
    function getNumbers() external view returns (uint[] memory out) {
        uint len = numbers.length;
        out = new uint[](len);
        for (uint i = 0; i < len; i++) {
            out[i] = numbers[i];
        }
    }

    // Reset numbers kembali ke 1..10
    function resetNumbers() public {
        delete numbers;
        for (uint i = 1; i <= 10; i++) {
            numbers.push(i);
        }
    }

    // WAJIB: terima array calldata dan append ke storage "numbers"
    function appendToNumbers(uint[] calldata _toAppend) external {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Simpan alamat pemanggil dan timestamp yang diberikan
    function saveTimestamp(uint _unixTimestamp) external {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    // Kembalikan timestamps > 946702800 beserta alamat pengirimnya
    function afterY2K() external view returns (uint[] memory ts, address[] memory addrs) {
        uint cutoff = 946702800;
        uint count;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > cutoff) count++;
        }
        ts = new uint[](count);
        addrs = new address[](count);
        uint idx;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > cutoff) {
                ts[idx] = timestamps[i];
                addrs[idx] = senders[i];
                idx++;
            }
        }
    }

    // Reset helper
    function resetSenders() public { delete senders; }
    function resetTimestamps() public { delete timestamps; }
}