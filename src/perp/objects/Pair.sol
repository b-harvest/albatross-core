// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import { SafeCastBytes32 } from "src/utils/libraries/SafeCastBytes32.sol";

import { StorageKey, Wallet, Cash, Account, Position } from "src/types/CustomTypes.sol";
import { StorageKeyLibrary } from "src/storage/libraries/StorageKeyLibrary.sol";

import { IdGenerator } from "src/storage/libraries/IdGenerator.sol";
import { InternalStorage } from "src/storage/InternalStorage.sol";

library PairFactory {
    StorageKey private constant _PAIR = StorageKey.wrap(keccak256(abi.encode("src.perp.objects.Pair")));

    uint256 private constant LEVERAGE_UNIT = 100;
    uint256 private constant GLOBAL_MAX_LEVERAGE = 500 * LEVERAGE_UNIT;
    uint256 private constant GLOBAL_MIN_LEVERAGE = 1.01 * LEVERAGE_UNIT;

    struct PairData {
        address underlying;
        uint16 minLeverage;
        uint16 maxLeverage;
    }

    function create(address _underlying, uint16 _minLeverage, uint16 _maxLeverage) internal {
        PairData storage pairData = read(_PAIR);

        require(_minLeverage > GLOBAL_MIN_LEVERAGE, "Min leverage must be greater than 1.01");
        require(_maxLeverage < GLOBAL_MAX_LEVERAGE, "Max leverage must be less than 500");

        pairData.underlying = _underlying;
        pairData.minLeverage = _minLeverage;
        pairData.maxLeverage = _maxLeverage;
    }

    function read(StorageKey _pair) internal view returns (PairData storage pairData) {
        pairData = PairData(0, 0, 0);
        pairData.underlying = _pair.readAddress(0);
        pairData.minLeverage = _pair.readUint16(1);
        pairData.maxLeverage = _pair.readUint16(2);
    }
}
