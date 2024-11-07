// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

type StorageKey is bytes32;

using { equalStorageKey as == } for StorageKey global;

function equalStorageKey(StorageKey a, StorageKey b) pure returns (bool) {
    return StorageKey.unwrap(a) == StorageKey.unwrap(b);
}

type TransientStorageKey is bytes32;

using { equalTransientStorageKey as == } for TransientStorageKey global;

function equalTransientStorageKey(TransientStorageKey a, TransientStorageKey b) pure returns (bool) {
    return TransientStorageKey.unwrap(a) == TransientStorageKey.unwrap(b);
}
