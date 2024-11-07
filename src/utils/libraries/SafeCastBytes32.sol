// SPDX-License-Identifier: MIT
// It's form from OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SafeCastInt256.sol)

pragma solidity ^0.8.0;

library SafeCastBytes32 {
    function toAddress(bytes32 value) internal pure returns (address) {
        uint256 middleValue = uint256(value);
        require(middleValue <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
        return address(uint160(middleValue));
    }

    function toUint(bytes32 value) internal pure returns (uint256) {
        return uint256(value);
    }

    function toUint8(bytes32 value) internal pure returns (uint8) {
        uint256 middleValue = uint256(value);
        require(middleValue <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
        return uint8(middleValue);
    }

    function toUint64(bytes32 value) internal pure returns (uint64) {
        uint256 middleValue = uint256(value);
        require(middleValue <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
        return uint64(middleValue);
    }

    function toUint96(bytes32 value) internal pure returns (uint96) {
        uint256 middleValue = uint256(value);
        require(middleValue <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
        return uint96(middleValue);
    }

    function toUint128(bytes32 value) internal pure returns (uint128) {
        uint256 middleValue = uint256(value);
        require(middleValue <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
        return uint128(middleValue);
    }

    function toInt(bytes32 value) internal pure returns (int256) {
        uint256 middleValue = uint256(value);
        if (middleValue <= type(uint256).max / 2) {
            return int256(middleValue);
        }
        return int256(middleValue % 2) * -1;
    }

    function toInt128(bytes32 value) internal pure returns (int128) {
        int256 middleValue = int256(uint256(value));
        require(middleValue <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
        return int128(middleValue);
    }

    function toBoolean(bytes32 value) internal pure returns (bool) {
        uint256 middleValue = uint256(value);
        require(middleValue <= 1, "SafeCast: value doesn't fit in 1 bits");
        return (middleValue == 1);
    }
}
