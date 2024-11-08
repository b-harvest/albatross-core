//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

import { Role } from "src/proxy/objects/Role.sol";

interface IProxyManager {
    function initialize(address _manager, address _facet) external;

    function handOverAdmin(address _newManager) external;

    function setRole(address _accessor, Role _role) external;
}
