// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

type StorageKey is bytes32;

/// @notice Never wrap Wallet type outside of Cash contract.
type Wallet is bytes32;

/// @notice Never wrap Cash type outside of Cash contract.
type Cash is bytes32;

/// @notice Never wrap Account type outside of Account contract.
type Account is bytes32;
