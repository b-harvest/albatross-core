// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

library Call {
    /**
     * @dev Call to the target using the given data. Revert when error occurs.
     * @param _target The target address to call.
     * @param _data The data used in the call.
     */
    function callWithRevert(address _target, bytes memory _data) internal returns (bytes memory) {
        (bool success, bytes memory result) = _target.call(_data);
        if (!success) {
            assembly {
                let ptr := mload(0x40)
                returndatacopy(ptr, 0, returndatasize())
                revert(ptr, returndatasize())
            }
        }
        return result;
    }

    /**
     * @dev Call to the multi target. Revert when error occurs.
     * @param _targets The target addresses to call.
     * @param _data The data used in the call.
     */
    function multicallWithRevert(address[] memory _targets, bytes[] memory _data)
        internal
        returns (bytes[] memory results)
    {
        results = new bytes[](_data.length);
        for (uint256 i = 0; i < _data.length; i++) {
            (bool success, bytes memory result) = _targets[i].call(_data[i]);

            if (!success) {
                assembly {
                    let ptr := mload(0x40)
                    returndatacopy(ptr, 0, returndatasize())
                    revert(ptr, returndatasize())
                }
            }
            results[i] = result;
        }
    }

    /**
     * @dev Call to the target using the given data. Just return when error occurs.
     * @param _target The target address to call.
     * @param _data The data used in the call.
     */
    function callWithNoRevert(address _target, bytes memory _data) internal returns (bytes memory) {
        (, bytes memory result) = _target.call(_data);
        return result;
    }

    /**
     * @dev Call to the multi target. Just return when error occurs.
     * @param _targets The target addresses to call.
     * @param _data The data used in the call.
     */
    function multicallWithNoRevert(address[] memory _targets, bytes[] memory _data)
        internal
        returns (bytes[] memory results)
    {
        results = new bytes[](_data.length);
        for (uint256 i = 0; i < _data.length; i++) {
            (, bytes memory result) = _targets[i].call(_data[i]);
            results[i] = result;
        }
    }
}
