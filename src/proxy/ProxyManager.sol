// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.11 <0.9.0;

import { IProxyManager } from "src/proxy/interfaces/IProxyManager.sol";

import { Context } from "src/proxy/objects/Context.sol";
import { DiamondFacet } from "src/proxy/objects/DiamondFacet.sol";
import { DiamondRBAC } from "src/proxy/objects/DiamondRBAC.sol";
import { Role, RoleType } from "src/proxy/objects/Role.sol";
import { ProxyError } from "src/proxy/errors/Error.sol";

contract ProxyManager is IProxyManager {
    function initialize(address _manager, address _facet) external override {
        // Grant manager role to msg.sender
        DiamondRBAC.authorize(_manager, RoleType.PROXY_MANAGER);

        // Set role of proxy management
        DiamondFacet.set(IProxyManager.handOverManager.selector, _facet, RoleType.PROXY_MANAGER);
        DiamondFacet.set(IProxyManager.setPublicFunc.selector, _facet, RoleType.PROXY_MANAGER);
        DiamondFacet.set(IProxyManager.setAuthorizedFunc.selector, _facet, RoleType.PROXY_MANAGER);
        DiamondFacet.set(IProxyManager.setRole.selector, _facet, RoleType.PROXY_MANAGER);
    }

    function handOverManager(address _newManager) external override {
        DiamondRBAC.unauthorize(Context.signer(), RoleType.PROXY_MANAGER);
        DiamondRBAC.authorize(_newManager, RoleType.PROXY_MANAGER);
    }

    function setPublicFunc(bytes4 _funcSelector, address _facet) external override {
        DiamondFacet.set(_funcSelector, _facet, RoleType.NONE);
    }

    function setAuthorizedFunc(bytes4 _funcSelector, address _facet, Role _requiredRole) external override {
        DiamondFacet.set(_funcSelector, _facet, _requiredRole);
    }

    function setRole(address _accessor, Role _role) external override {
        if (_role == RoleType.PROXY_MANAGER) {
            revert ProxyError.SetRoleAsProxyManager();
        }
        DiamondRBAC.authorize(_accessor, _role);
    }
}
