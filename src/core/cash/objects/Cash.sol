//SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.11 <0.9.0;

import { Context } from "src/proxy/objects/Context.sol";

import { IERC20 } from "src/utils/interfaces/IERC20.sol";
import { SafeERC20 } from "src/utils/libraries/SafeERC20.sol";
import { SafeCastU256 } from "src/utils/libraries/SafeCastU256.sol";
import { SafeCastBytes32 } from "src/utils/libraries/SafeCastBytes32.sol";

import { StorageKey, Wallet, Cash } from "src/types/CustomTypes.sol";
import { StorageKeyLibrary } from "src/storage/libraries/StorageKeyLibrary.sol";

import { IdGenerator } from "src/storage/libraries/IdGenerator.sol";
import { InternalStorage } from "src/storage/InternalStorage.sol";
import { TransientStorage } from "src/storage/TransientStorage.sol";

import { CashError } from "src/core/cash/errors/Error.sol";
import { CashEvent } from "src/core/cash/events/Event.sol";

library CashFactory {
    using IdGenerator for StorageKey;
    using StorageKeyLibrary for StorageKey;
    using SafeCastBytes32 for bytes32;
    using SafeCastU256 for uint256;
    using SafeERC20 for IERC20;

    StorageKey private constant _WALLET = StorageKey.wrap(keccak256(abi.encode("src.core.cash.Wallet")));
    StorageKey private constant _CASH = StorageKey.wrap(keccak256(abi.encode("src.core.cash.Cash")));

    /// In-Storage Object
    struct WalletData {
        uint256 balance; // Decimal 18
    }

    /// @dev Create Cash object stored in storage.
    function createWallet(address _erc20Address) internal returns (Wallet wallet) {
        if (_erc20Address == address(0x0)) {
            revert CashError.ERC20AddressZero();
        }
        uint256 id = _WALLET.generateStorageId();
        if (id > 2 ** 96) {
            revert CashError.WalletIdOverflow(id);
        }
        wallet = Wallet.wrap((uint256(uint160(_erc20Address)) << 96) + id);
    }

    /// Transient-storage Object
    struct CashData {
        uint256 balance; // Decimal 18
        uint256 debt; // Decimal 18
    }

    /// @dev Create Cash cache stored in storage.
    function createCash(address _erc20Address) internal returns (Cash cash) {
        if (_erc20Address == address(0x0)) {
            revert CashError.ERC20AddressZero();
        }
        uint256 id = _CASH.generateTransientId();
        cash = Cash.wrap((uint256(uint160(_erc20Address)) << 96) + id);
    }

    /**
     * @dev Deposit ERC20 and mint cash.
     * @param _erc20Address The address of ERC20 to deposit.
     * @param _amountWithERC20Decimal Amount of ERC20 to mint. It considered decimal.
     */
    function wrapERC20ToCash(address _erc20Address, address _from, uint256 _amountWithERC20Decimal)
        internal
        returns (Cash cash)
    {
        // 0. Get decimal of ERC20
        uint8 decimal = IERC20(_erc20Address).decimals();

        // 1. Transfer from erc20 cash.
        IERC20(_erc20Address).safeTransferFrom(_from, address(this), _amountWithERC20Decimal);

        // 2. Calculate minting amount.
        uint256 mintAmount = (decimal >= 18)
            ? _amountWithERC20Decimal / (10 ** (decimal - 18))
            : _amountWithERC20Decimal * (10 ** (18 - decimal));

        // 3. Mint cash
        cash = createCash(_erc20Address);

        // 4. Store data
        storeCashAmount(cash, mintAmount);

        // 5. Emit event.
        emit CashEvent.DepositCash(_from, _erc20Address, mintAmount);
    }

    /**
     * @dev Withdraw ERC20 from cash.
     */
    function unwrapCashToERC20(Cash _cash, address _to) internal {
        // 0. Get cash data.
        uint256 cashAmount = readCashAmount(_cash);

        // 1. If cash amount is zero, return.
        if (cashAmount == 0) {
            return;
        }

        // 2. Clear cash data.
        storeCashAmount(_cash, 0);

        // 3. Declare local variables.
        address erc20Address = ERC20Address(_cash);
        uint8 decimal = IERC20(erc20Address).decimals();

        // 4. Calculate output amount with decimal.
        uint256 amountWithDecimal =
            (decimal >= 18) ? cashAmount * (10 ** (decimal - 18)) : cashAmount / (10 ** (18 - decimal));

        // 5. Transfer erc20 to `_to`.
        IERC20(erc20Address).safeTransfer(_to, amountWithDecimal);

        // 6. Emit event.
        emit CashEvent.WithdrawCash(_to, erc20Address, cashAmount);
    }

    /**
     * @dev Transfer the given amount of cash from `_from` to `_to`.
     */
    function transfer(Cash _from, Cash _to, uint256 _amount) internal {
        // 0. If amount is zero, return.
        if (_amount == 0) {
            return;
        }

        // 1. Check balance
        uint256 fromBalance = readCashAmount(_from);
        if (fromBalance < _amount) {
            revert CashError.TransferAmountNotEnough(fromBalance, _amount);
        }

        // 2. Check if `_from` and `_to` are the same erc20 based cash.
        if (ERC20Address(_from) != ERC20Address(_to)) {
            revert CashError.NotEqualCash(ERC20Address(_from), ERC20Address(_to));
        }

        // 3. Update storage
        storeCashAmount(_from, fromBalance - _amount);
        storeCashAmount(_to, readCashAmount(_to) + _amount);
    }

    /**
     * @dev Take out the given amount of cash from the wallet.
     */
    function takeOut(Wallet _wallet, uint256 _amount) internal returns (Cash cash) {
        // 0. Check balance
        uint256 walletBalance = readWalletBalance(_wallet);
        if (walletBalance < _amount) {
            revert CashError.ExtractAmountNotEnough(walletBalance, _amount);
        }

        // 1. Create cash cache
        address erc20Address = ERC20Address(_wallet);
        cash = createCash(erc20Address);

        // 2. Update storage
        storeWalletBalance(_wallet, walletBalance - _amount);
        storeCashAmount(cash, _amount);
    }

    /**
     * @dev Put the given cash into the wallet.
     */
    function putIn(Wallet _wallet, Cash _cash) internal {
        // 0. Check if `_wallet` and `_cash` are the same erc20 based.
        if (ERC20Address(_wallet) != ERC20Address(_cash)) {
            revert CashError.NotEqualCash(ERC20Address(_wallet), ERC20Address(_cash));
        }

        // 1. Update storage
        storeWalletBalance(_wallet, readWalletBalance(_wallet) + readCashAmount(_cash));
        storeCashAmount(_cash, 0);
    }

    /// <---- VIEW FUNCTIONS ---->
    function ERC20Address(Wallet _cash) internal pure returns (address) {
        return (Wallet.unwrap(_cash) >> 96).toAddress();
    }

    function ERC20Address(Cash _cash) internal pure returns (address) {
        return (Cash.unwrap(_cash) >> 96).toAddress();
    }

    function initialized(Wallet _cash) internal pure returns (bool) {
        return Wallet.unwrap(_cash) != 0;
    }

    function initialized(Cash _cash) internal pure returns (bool) {
        return Cash.unwrap(_cash) != 0;
    }

    function balance(Wallet _cash) internal view returns (uint256) {
        return readWalletBalance(_cash);
    }

    function amount(Cash _cash) internal view returns (uint256) {
        return readCashAmount(_cash);
    }

    /// <---- PRIVATE FUNCTIONS ---->
    /// @dev Store wallet balance to storage.
    function storeWalletBalance(Wallet _wallet, uint256 _balance) private {
        InternalStorage.writeUint256(_WALLET.derive(_wallet), _balance);
    }

    /// @dev Store cash amount to transient-storage.
    function storeCashAmount(Cash _token, uint256 _amount) private {
        TransientStorage.writeUint256(_CASH.derive(_token), _amount);
    }

    /// @dev Read wallet balance from storage.
    function readWalletBalance(Wallet _wallet) private view returns (uint256) {
        return InternalStorage.readUint256(_WALLET.derive(_wallet));
    }

    /// @dev Read cash amount from transient-storage.
    function readCashAmount(Cash _token) private view returns (uint256) {
        return TransientStorage.readUint256(_CASH.derive(_token));
    }
}
