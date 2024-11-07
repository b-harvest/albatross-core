// SPDX-License-Identifier: MIT
// It's form from OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SafeCastInt256.sol)

pragma solidity ^0.8.0;

library SafeCastU256 {
    function toUint64(uint256 value) internal pure returns (uint64) {
        require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
        return uint64(value);
    }

    function toUint128(uint256 value) internal pure returns (uint128) {
        require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
        return uint128(value);
    }

    function toInt256(uint256 value) internal pure returns (int256) {
        // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
        require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
        return int256(value);
    }

    function toAddress(uint256 value) internal pure returns (address) {
        require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
        return address(uint160(value));
    }
}
