// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Role, RoleType } from "src/proxy/objects/Role.sol";

/*
 * @dev Viewer is a contract that can be called outside the protocol. Similar to user interface.
 */
abstract contract IViewer {
    // @dev Role means the access rights of the controller.
    // If Viewer, it can be called publicly.
    Role public constant ROLE = RoleType.VIEWER;
}
