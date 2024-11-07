// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { StorageKey } from "src/types/CustomTypes.sol";

library TransientStorage {
    /*
     * @dev Write uint256 value to transient storage
     * @param _key StorageKey to write
     * @param _value Value to write
     */
    function writeUint256(StorageKey _key, uint256 _value) internal {
        assembly {
            sstore(_key, _value)
        }
    }

    /*
     * @dev Read uint256 value from transient storage
     * @param _key StorageKey to read
     * @return Value read from storage
     */
    function readUint256(StorageKey _key) internal view returns (uint256 value) {
        assembly {
            value := tload(_key)
        }
    }

    /*
     * @dev Write address value to transient storage
     * @param _key StorageKey to write
     * @param _value Value to write
     */
    function writeAddress(StorageKey _key, address _value) internal {
        assembly {
            sstore(_key, _value)
        }
    }

    /*
     * @dev Read address value from transient storage
     * @param _key StorageKey to read
     * @return Value read from storage
     */
    function readAddress(StorageKey _key) internal view returns (address value) {
        assembly {
            value := tload(_key)
        }
    }

    /*
     * @dev Write bool value to transient storage
     * @param _key StorageKey to write
     * @param _value Value to write
     */
    function writeBool(StorageKey _key, bool _value) internal {
        assembly {
            sstore(_key, _value)
        }
    }

    /*
     * @dev Read bool value from transient storage
     * @param _key StorageKey to read
     * @return Value read from storage
     */
    function readBool(StorageKey _key) internal view returns (bool value) {
        assembly {
            value := tload(_key)
        }
    }

    /*
     * @dev Write bytes32 value to transient storage
     * @param _key StorageKey to write
     * @param _value Value to write
     */
    function writeBytes32(StorageKey _key, bytes32 _value) internal {
        assembly {
            sstore(_key, _value)
        }
    }

    /*
     * @dev Read bytes32 value from transient storage
     * @param _key StorageKey to read
     * @return Value read from storage
     */
    function readBytes32(StorageKey _key) internal view returns (bytes32 value) {
        assembly {
            value := tload(_key)
        }
    }
}
