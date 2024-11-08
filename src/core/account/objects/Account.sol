// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

import { Context } from "../../../proxy/objects/Context.sol";
import { SafeCastBytes32 } from "../../../utils/libraries/SafeCastBytes32.sol";

import { StorageKey, Wallet, Cash, Account } from "src/types/CustomTypes.sol";
import { StorageKeyLibrary } from "src/storage/libraries/StorageKeyLibrary.sol";

import { IdGenerator } from "src/storage/libraries/IdGenerator.sol";
import { InternalStorage } from "src/storage/InternalStorage.sol";

import { AccountError } from "../errors/Error.sol";
import { AccountEvent } from "../events/Event.sol";

/**
 * @title AccountLibrary
 * @dev This library provides functions for managing user accounts and their associated data.
 */
library AccountLibrary {
    using SafeCastBytes32 for bytes32;

    // Storage key for the account data
    StorageKey private constant _ACCOUNT = StorageKey.wrap(keccak256(abi.encode("src.core.account.objects.Account")));

    /**
     * @dev Authorize an account.
     * @param _account The account to authorize.
     * @return _authorizedAccount The authorized account.
     */
    function authorize(Account _account) internal view returns (Account _authorizedAccount) {
        // Check if the account owner matches the signer
        if (owner(_account) != Context.signer()) {
            revert AccountError.AuthorizationFailed(_account, Context.signer());
        }

        // Set the first bit of the Account (most significant bit) to 1
        assembly {
            _authorizedAccount := or(_account, shl(255, 1)) // Set the highest bit to 1
        }
    }

    /**
     * @dev Get a account object.
     * @param _owner The address of the account owner.
     * @return _account The account object of owner.
     */
    function getAccount(address _owner) internal pure returns (Account _account) {
        assembly {
            _account := _owner
        }
    }

    /**
     * @dev Check if an account is authorized.
     * @param _account The account to check.
     * @return _result True if the account is authorized, false otherwise.
     */
    function authorized(Account _account) internal pure returns (bool _result) {
        assembly {
            // Check if the highest bit (most significant bit) is set
            _result := iszero(iszero(and(_account, shl(255, 1))))
        }
    }

    /**
     * @dev Get the owner address of the account.
     * @param _account The account for which the owner address is retrieved.
     * @return _owner The owner address of the account.
     */
    function owner(Account _account) internal pure returns (address _owner) {
        assembly {
            _owner := _account
        }
    }
}
