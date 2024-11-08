// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.11 <0.9.0;

import { IProxyManager } from "src/proxy/interfaces/IProxyManager.sol";

import { Context } from "src/proxy/objects/Context.sol";
import { DiamondFacet } from "src/proxy/objects/DiamondFacet.sol";
import { DiamondRBAC } from "src/proxy/objects/DiamondRBAC.sol";
import { Role, RoleType } from "src/proxy/objects/Role.sol";
import { ProxyError } from "src/proxy/errors/Error.sol";

contract ProxyManager is IProxyManager {
    function initialize(address _admin, address _facet) external override {
        // Grant manager role to msg.sender
        DiamondRBAC.authorize(_admin, RoleType.PROXY_ADMIN);

        // Set role of proxy management
        DiamondFacet.set(IProxyManager.handOverAdmin.selector, _facet, RoleType.PROXY_ADMIN);
        DiamondFacet.set(IProxyManager.setRole.selector, _facet, RoleType.PROXY_ADMIN);
    }

    function setVersion(uint48 _newVersion) external {
        DiamondRBAC.authorize(_newVersion, RoleType.PROXY_ADMIN);
    }

    function handOverAdmin(address _newManager) external override {
        DiamondRBAC.unauthorize(Context.signer(), RoleType.PROXY_ADMIN);
        DiamondRBAC.authorize(_newManager, RoleType.PROXY_ADMIN);
    }

    function setRole(address _accessor, Role _role) external override {
        if (_role == RoleType.PROXY_ADMIN) {
            revert ProxyError.SetRoleAsProxyManager();
        }
        DiamondRBAC.authorize(_accessor, _role);
    }
}
