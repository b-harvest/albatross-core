// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Role } from "src/proxy/objects/Role.sol";

/*
 * @dev Controller is a contract that can be called outside the protocol. Similar to user interface.
 *      Authority operates in the form of RBAC in the proxy.
 */
interface IController {
    // @dev Role means the access rights of the controller.
    function ROLE() external view returns (Role);
}
