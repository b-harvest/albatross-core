// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

type StorageKey is bytes32;

/// <------- Perpetual Types ------->
type Position is bytes32;

type Pair is bytes32;

/// <------- Lending Types ------->
type Debt is bytes32;

type Collateral is bytes32;

/// <------- Core Types ------->
/// @dev Never wrap common types outside of specific libraries !!!!
type Wallet is bytes32;

type Cash is bytes32;

type Account is bytes32;
