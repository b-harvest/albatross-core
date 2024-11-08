// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

type Role is uint96;

using { equal as == } for Role global;

function equal(Role _left, Role _right) pure returns (bool) {
    return Role.unwrap(_left) == Role.unwrap(_right);
}

library RoleType {
    /// @dev It is dangerous if the same value exists.
    Role internal constant NONE = Role.wrap(0);
    Role internal constant PROXY_ADMIN = Role.wrap(1);
    Role internal constant ORACLE_CONFIG_ADMIN = Role.wrap(2);

    /// keeper
    Role internal constant ORACLE_KEEPER = Role.wrap(3);
    Role internal constant ORDER_KEEPER = Role.wrap(4);

    /// admin
    Role internal constant DERIVATIVE_ADMIN = Role.wrap(5);
    Role internal constant FEE_CONFIG_ADMIN = Role.wrap(6);

    Role internal constant VIEWER = Role.wrap(type(uint96).max);
}
