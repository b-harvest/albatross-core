//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

library CashError {
    /**
     * @notice Thrown when new underlying cash is already exist in list.
     * @param _asset The address of asset which is already exist.
     */
    error AlreadyExistUnderlying(address _asset);

    /**
     * @notice Thrown when input asset is not underlying asset
     * @param _asset The address of asset which is not allowed.
     */
    error NotUnderlyingAsset(address _asset);

    /**
     * @notice Thrown when underlying asset deppeging occurs.
     * @param _asset The address of asset which is depegged.
     */
    error DepeggingUlAsset(address _asset);

    /**
     * @notice Thrown when input cash ratio is not equal with underlying
     * @param _asset The address of asset which ratio is not equal.
     */
    error InvalidCashRatio(address _asset);

    /**
     * @notice Thrown when two cash assets are not equal
     * @param _firstAsset The address of first asset.
     * @param _secondAsset The address of second asset.
     */
    error NotEqualCash(address _firstAsset, address _secondAsset);

    /**
     * @notice Thrown when erc20 address zero
     */
    error ERC20AddressZero();

    /**
     * @notice Thrown when Integrity is not valid
     */
    error InvalidIntegrity();

    /**
     * @notice Thrown when cash extraction amount is not enough
     */
    error ExtractAmountNotEnough(uint256 _balance, uint256 _amount);

    /**
     * @notice Thrown when cash transfer amount is not enough
     */
    error TransferAmountNotEnough(uint256 _fromAmount, uint256 _transferAmount);

    /**
     * @notice Thrown when cash amount is too large
     */
    error TooLargeAmountToParameterization(uint256 _amount);

    /**
     * @notice Thrown when cash debt is remain
     */
    error DebtRemain(uint256 debt);

    /**
     * @notice Thrown when wallet id is overflow
     */
    error WalletIdOverflow(uint256 _walletId);
}
