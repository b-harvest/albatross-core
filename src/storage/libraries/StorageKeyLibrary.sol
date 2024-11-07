// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { StorageKey } from "src/types/CustomTypes.sol";

/*
 * @title StorageKeyLibrary
 * @dev Library for storage key derivation from seed
 */
library StorageKeyLibrary {
    /*
     * @dev Derive storage key from existing key and address type seed
     * @param _storage StorageKey to derive
     * @param _seed Address type seed to derive
     * @return Derived storage key
     */
    function derive(StorageKey _storage, address _seed) internal pure returns (StorageKey) {
        return StorageKey.wrap(keccak256(abi.encode(_storage, _seed)));
    }

    /*
     * @dev Derive storage key from existing key and bytes32 type seed
     * @param _storage StorageKey to derive
     * @param _seed Bytes32 type seed to derive
     * @return Derived storage key
     */
    function derive(StorageKey _storage, bytes32 _seed) internal pure returns (StorageKey) {
        return StorageKey.wrap(keccak256(abi.encode(_storage, _seed)));
    }

    /*
     * @dev Derive storage key from key and uint256 type seed
     * @param _storage StorageKey to derive
     * @param _seed Uint256 type seed to derive
     * @return Derived storage key
     */
    function derive(StorageKey _storage, uint256 _seed) internal pure returns (StorageKey) {
        return StorageKey.wrap(keccak256(abi.encode(_storage, _seed)));
    }

    /*
     * @dev Derive storage key from key and string type seed
     * @param _storage StorageKey to derive
     * @param _seed String type seed to derive
     * @return Derived storage key
     */
    function derive(StorageKey _storage, string memory _seed) internal pure returns (StorageKey) {
        return StorageKey.wrap(keccak256(abi.encode(_storage, _seed)));
    }
}
