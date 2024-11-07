// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 */
library ECDSA {
    /**
     * @notice Thrown when signature length is not 65.
     * @param _length The length of signature.
     */
    error InvalidSignatureLength(uint256 _length);

    /**
     * @notice Thrown when operation signer recovered by signature not match with signer.
     * @param _signer The address of signer.
     * @param _operationSigner The address of signer recovered by signature.
     */
    error SignerNotMatch(address _signer, address _operationSigner);

    /**
     * @notice Thrown when signature is invalid.
     * @param _signature The signature info.
     */
    error InvalidSignature(bytes _signature);

    function validateHash(address _signer, bytes memory _signature, bytes32 _operationHash) internal pure {
        if (_signature.length != 65) {
            revert InvalidSignatureLength(_signature.length);
        }

        address operationSigner = recover(_operationHash, _signature);
        if (_signer != operationSigner) {
            revert SignerNotMatch(_signer, operationSigner);
        }
    }

    function recover(bytes32 _operationHash, bytes memory _signature) private pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        /// @solidity memory-safe-assembly
        assembly {
            r := mload(add(_signature, 0x20))
            s := mload(add(_signature, 0x40))
            v := byte(0, mload(add(_signature, 0x60)))
        }
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            revert InvalidSignature(_signature);
        }

        if (v < 27) {
            v += 27;
        }

        // If the signature is valid (and not malleable), return the signer address
        return ecrecover(_operationHash, v, r, s);
    }
}
