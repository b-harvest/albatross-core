// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.11 <0.9.0;

import { SafeCastBytes32 } from "src/utils/libraries/SafeCastBytes32.sol";

import { StorageKey } from "src/types/CustomTypes.sol";
import { StorageKeyLibrary } from "src/storage/libraries/StorageKeyLibrary.sol";

import { DiamondRBAC } from "src/proxy/objects/DiamondRBAC.sol";
import { Role, RoleType } from "src/proxy/objects/Role.sol";

import { ProxyError } from "src/proxy/errors/Error.sol";

/**
 * @title DiamondFacet Library
 * @dev Modified Diamond proxy storage.
 *      Singleton Library
 */
library DiamondFacet {
    using StorageKeyLibrary for StorageKey;
    using SafeCastBytes32 for bytes32;

    /// Constant
    StorageKey private constant _FACET_STORAGE = StorageKey.wrap(keccak256(abi.encode("src.proxy.objects.DiamondFacet")));

    /**
     * @dev Represents the data structure for a facet.
     */
    struct Data {
        address facet;
        Role requiredRole;
    }

    /**
     * @dev Sets the facet for a given function selector with a required role.
     * @param _funcSelector The function selector.
     * @param _facet The address of the facet.
     * @param _requiredRole The required role for accessing the facet.
     */
    function set(bytes4 _funcSelector, address _facet, Role _requiredRole) internal {
        Data storage data = read(_funcSelector);
        data.facet = _facet;
        data.requiredRole = _requiredRole;
    }

    /**
     * @dev Gets the facet for a function selector and checks if the accessor has the required role.
     * @param _accessor The address of the accessor.
     * @param _funcSelector The function selector.
     * @return facet The address of the facet.
     * @return isViewFunction A boolean
     */
    function get(address _accessor, bytes4 _funcSelector) internal view returns (address facet, bool isViewFunction) {
        Data memory data = read(_funcSelector);
        if (data.facet == address(0)) {
            revert ProxyError.FacetNotFound(_accessor, _funcSelector);
        }
        if (data.requiredRole == RoleType.VIEWER) {
            return (data.facet, true);
        }
        if (!(data.requiredRole == RoleType.NONE) && (!DiamondRBAC.hasRole(_accessor, data.requiredRole))) {
            revert ProxyError.NotAuthorized(_accessor, _funcSelector);
        }
        return (data.facet, false);
    }

    /**
     * @dev Returns the data stored at the specified key.
     */
    function read(bytes4 _funcSelector) private pure returns (Data storage data) {
        StorageKey key = _FACET_STORAGE.derive(_funcSelector);
        assembly {
            data.slot := key
        }
    }
}
