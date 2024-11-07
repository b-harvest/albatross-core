// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.11 <0.9.0;

import { SafeCastBytes32 } from "src/utils/libraries/SafeCastBytes32.sol";

import { ProxyError } from "src/proxy/errors/Error.sol";
import { StorageKey } from "src/types/CustomTypes.sol";
import { TransientStorage } from "src/storage/TransientStorage.sol";
import { StorageKeyLibrary } from "src/storage/libraries/StorageKeyLibrary.sol";

/* @title Context Library
 * @dev Library for context management in the proxy contract.
 */
library Context {
    using TransientStorage for StorageKey;
    using StorageKeyLibrary for StorageKey;
    using SafeCastBytes32 for bytes32;

    StorageKey private constant _SIGNER_STORAGE =
        StorageKey.wrap(keccak256(abi.encode("src.proxy.objects.Context.signer")));
    StorageKey private constant _KEEPER_STORAGE =
        StorageKey.wrap(keccak256(abi.encode("src.proxy.objects.Context.keeper")));
    StorageKey private constant _CRITICAL_TASK_COUNT_STORAGE =
        StorageKey.wrap(keccak256(abi.encode("src.proxy.objects.Context.criticalTaskCountInProgress")));

    // Data structure to store the context
    struct Data {
        address signer;
        address keeper;
        uint256 criticalTaskCountInProgress;
    }

    /**
     * @notice Initialize the context. If the context is already locked, the tx will be reverted.
     */
    function initialize() internal {
        address originalSigner = _SIGNER_STORAGE.readAddress();

        // Check if the context is locked
        if (originalSigner != address(0)) {
            revert ProxyError.ContextConflict(originalSigner, msg.sender);
        }

        _SIGNER_STORAGE.writeAddress(msg.sender);
    }

    /**
     * @notice Clear the context. If a critical task is in progress, the tx will be reverted.
     */
    function clear() internal {
        uint256 criticalTaskCount = _CRITICAL_TASK_COUNT_STORAGE.readUint256();

        if (criticalTaskCount > 0) {
            revert ProxyError.CriticalTaskInProgress(criticalTaskCount);
        }

        _SIGNER_STORAGE.writeAddress(address(0));
        _KEEPER_STORAGE.writeAddress(address(0));
    }

    /*
     * @notice This function is used to replace the current signer address with a new one.
     * @param _newSigner The new signer's address.
     */
    function replaceSigner(address _newSigner) internal {
        _KEEPER_STORAGE.writeAddress(signer());
        _SIGNER_STORAGE.writeAddress(_newSigner);
    }

    /**
     * @notice Run a critical task. This function is used to count the number of critical tasks in progress.
     * If the number of critical tasks in progress is greater than 0 at end of request, the request will be rejected.
     */
    function runCriticalTask() internal {
        uint256 count = _CRITICAL_TASK_COUNT_STORAGE.readUint256();
        _CRITICAL_TASK_COUNT_STORAGE.writeUint256(count + 1);
    }

    /**
     * @notice End a critical task. This function is used to decrement the number of critical tasks in progress.
     * If the number of critical tasks in progress is 0, the request will be rejected.
     */
    function endCriticalTask() internal {
        uint256 count = _CRITICAL_TASK_COUNT_STORAGE.readUint256();

        // If no critical task is in progress, revert the transaction
        if (count == 0) {
            revert ProxyError.NoCriticalTask();
        }

        _CRITICAL_TASK_COUNT_STORAGE.writeUint256(count - 1);
    }

    /**
     * @notice Get the signer address.
     */
    function signer() internal view returns (address) {
        return _SIGNER_STORAGE.readAddress();
    }

    /**
     * @notice Get the keeper address.
     */
    function keeper() internal view returns (address) {
        return _KEEPER_STORAGE.readAddress();
    }
}
