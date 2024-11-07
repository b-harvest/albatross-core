//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

library ProxyError {
    /// @dev Error thrown when there is a context conflict.
    error ContextConflict(address oldCaller, address newCaller);

    /**
     * @notice Thrown when no facet in this function signature.
     * @param _accessor The address of access user.
     * @param _funcSelector The signature of function.
     */
    error FacetNotFound(address _accessor, bytes4 _funcSelector);

    /**
     * @notice Thrown when caller was not authorized.
     * @param _accessor The address of access user.
     * @param _funcSelector The signature of function.
     */
    error NotAuthorized(address _accessor, bytes4 _funcSelector);

    /**
     * @notice Thrown when no dependency in this function signature.
     * @param _accessor The address of accessor.
     * @param _slot The index of dependency slot.
     */
    error NoDependency(address _accessor, uint8 _slot);

    /**
     * @notice Thrown when set dependency self.
     * @param _dependency The address of dependency.
     */
    error SelfDependency(address _dependency);

    /**
     * @notice Thrown when critical task in progress at end of request.
     * @param _taskCount The number of critical tasks in progress.
     */
    error CriticalTaskInProgress(uint256 _taskCount);

    /**
     * @notice Thrown when end critical task without any critical task.
     */
    error NoCriticalTask();

    /**
     * @notice Thrown when set role as proxy manager.
     */
    error SetRoleAsProxyManager();
}
