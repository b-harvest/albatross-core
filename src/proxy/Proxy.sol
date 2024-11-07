// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.11 <0.9.0;

import { DelegateCall } from "src/utils/libraries/DelegateCall.sol";
import { Call } from "src/utils/libraries/Call.sol";

import { IProxyManager } from "src/proxy/interfaces/IProxyManager.sol";

import { Context } from "src/proxy/objects/Context.sol";
import { DiamondFacet } from "src/proxy/objects/DiamondFacet.sol";
import { DiamondRBAC } from "src/proxy/objects/DiamondRBAC.sol";
import { ProxyManager } from "src/proxy/ProxyManager.sol";
import { ProxyError } from "src/proxy/errors/Error.sol";
import { Extsload } from "src/utils/Extsload.sol";
import { Exttload } from "src/utils/Exttload.sol";

contract Proxy is Extsload, Exttload {
    constructor(address _proxyManager) {
        // Deploy if there is no existing proxy manager
        if (_proxyManager == address(0)) {
            _proxyManager = address(new ProxyManager());
        }

        // Initialize Proxy Manager
        DelegateCall.callWithRevert(
            _proxyManager, abi.encodeWithSelector(IProxyManager.initialize.selector, msg.sender, _proxyManager)
        );
    }

    /**
     * @dev Fallback function that delegates calls to the target.
     */
    fallback() external payable {
        if (msg.sender == address(this)) {
            _fromInside();
        } else {
            _fromOutside();
        }
    }

    receive() external payable { }

    /**
     * @dev Executes a function call from outside of this contract to facet using delegate call.
     */
    function _fromOutside() internal {
        (address facet, bool isViewFunction) = DiamondFacet.get(msg.sender, msg.sig);
        // Initialize context storage
        if (!isViewFunction) {
            Context.initialize();
        }
        // Delegate call to facet
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            // execute function delegate call to facet
            let result := delegatecall(gas(), facet, ptr, calldatasize(), 0, 0)
            // get any return value
            if eq(result, false) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
        // Clear context storage
        if (!isViewFunction) {
            Context.clear();
        }
        // Return data
        assembly {
            returndatacopy(0, 0, returndatasize())
            return(0, returndatasize())
        }
    }

    /**
     * @dev Executes a function call from inside of this contract.
     */
    function _fromInside() internal {
        // Call to internal target.
        // It's using delegate call.
        assembly {
            // Load the first parameter from calldata (assume it's an address)
            let target := shr(96, calldataload(4)) // Extract the first parameter (address type)

            // Allocate memory for calldata copy
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            // Execute delegatecall with the extracted 'target'
            let result := delegatecall(gas(), target, ptr, calldatasize(), 0, 0)

            // Handle return data
            if eq(result, 0) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
            returndatacopy(0, 0, returndatasize())
            return(0, returndatasize())
        }
    }
}
