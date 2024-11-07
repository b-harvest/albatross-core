// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.11 <0.9.0;

import { SafeCastBytes32 } from "src/utils/libraries/SafeCastBytes32.sol";

import { StorageKey } from "src/types/CustomTypes.sol";

import { Role } from "src/proxy/objects/Role.sol";

/**
 * @dev Modified Diamond storage for Role-Based Access Control (RBAC).
 *      Singleton Library for managing roles.
 */
library DiamondRBAC {
    using SafeCastBytes32 for bytes32;

    StorageKey private constant _ROLE = StorageKey.wrap(keccak256(abi.encode("src.proxy.objects.DiamondRBAC")));

    // Data structure to store role ownership status
    struct Data {
        bool owned; // Ownership status of the role
    }

    /**
     * @dev Authorize an accessor to hold a specific role.
     * @param _accessor The address of the accessor to be authorized.
     * @param _role The role to be authorized.
     */
    function authorize(address _accessor, Role _role) internal {
        Data storage data = read(_accessor, _role);
        data.owned = true;
    }

    /**
     * @dev Unauthorize an accessor from holding a specific role.
     * @param _accessor The address of the accessor to be unauthorized.
     * @param _role The role to be unauthorized.
     */
    function unauthorize(address _accessor, Role _role) internal {
        Data storage data = read(_accessor, _role);
        data.owned = false;
    }

    /**
     * @dev Check if an accessor holds a specific role.
     * @param _accessor The address of the accessor to check.
     * @param _role The role to check.
     * @return bool true if the accessor holds the role, false otherwise.
     */
    function hasRole(address _accessor, Role _role) internal view returns (bool) {
        return read(_accessor, _role).owned;
    }

    /**
     * @dev Returns the data stored at the specified key.
     * @param _accessor The address of the accessor to read data for.
     * @param _role The role to read data for.
     * @return data The data stored for the accessor and role (ownership status).
     */
    function read(address _accessor, Role _role) private pure returns (Data storage data) {
        bytes32 key = getKey(_accessor, _role);
        assembly {
            data.slot := key
        }
    }

    /**
     * @dev Returns the storage key for a specific accessor and role.
     * @param _accessor The address of the accessor.
     * @param _role The role to generate a key for.
     * @return The storage key associated with the accessor and role.
     */
    function getKey(address _accessor, Role _role) private pure returns (bytes32) {
        return keccak256(abi.encode(_ROLE, _accessor, _role));
    }
}
