//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

import { Role } from "src/proxy/objects/Role.sol";

interface IProxyManager {
    function initialize(address _manager, address _facet) external;

    function handOverManager(address _newManager) external;

    function setPublicFunc(bytes4 _funcSelector, address _facet) external;

    function setAuthorizedFunc(bytes4 _funcSelector, address _facet, Role _requiredRole) external;

    function setRole(address _accessor, Role _role) external;
}
