// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { StorageKey } from "src/types/CustomTypes.sol";
import { StorageKeyLibrary } from "./StorageKeyLibrary.sol";
import { InternalStorage } from "src/storage/InternalStorage.sol";
import { TransientStorage } from "src/storage/TransientStorage.sol";

library IdGenerator {
    using StorageKeyLibrary for StorageKey;

    StorageKey private constant _ID_GENERATOR = StorageKey.wrap(keccak256(abi.encode("src.utils.objects.IdGenerator")));

    /*
     * @dev Generate storage id
     * @param _key StorageKey to generate id
     * @return Generated id
     */
    function generateStorageId(StorageKey _key) internal returns (uint256 newId) {
        StorageKey key = _ID_GENERATOR.derive(_key);
        newId = InternalStorage.readUint256(key) + 1;
        InternalStorage.writeUint256(key, newId);
    }

    /*
     * @dev Generate transient id
     * @param _key StorageKey to generate id
     * @return Generated id
     */
    function generateTransientId(StorageKey _key) internal returns (uint256 newId) {
        StorageKey key = _ID_GENERATOR.derive(_key);
        newId = TransientStorage.readUint256(key) + 1;
        TransientStorage.writeUint256(key, newId);
    }
}
