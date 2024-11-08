//// SPDX-License-Identifier: BUSL-1.1
//pragma solidity ^0.8.0;
//
//import { SafeCastBytes32 } from "src/utils/libraries/SafeCastBytes32.sol";
//
//import { StorageKey, Wallet, Cash, Account, Position } from "src/types/CustomTypes.sol";
//import { StorageKeyLibrary } from "src/storage/libraries/StorageKeyLibrary.sol";
//
//import { IdGenerator } from "src/storage/libraries/IdGenerator.sol";
//import { InternalStorage } from "src/storage/InternalStorage.sol";
//
//library PositionFactory {
//    using SafeCastBytes32 for bytes32;
//
//    StorageKey private constant _POSITION = StorageKey.wrap(keccak256(abi.encode("src.perp.objects.Position")));
//
//    struct Data {
//        uint120 openUlPrice;
//        uint120 size;
//        uint16 leverage;
//    }
//
//    /**
//     * @notice Open a position
//     * @param _position The position to open
//     * @param _ulPrice The underlying price
//     * @param _size The size of the position
//     * @param _leverage The leverage of the position
//     */
//    function open(Account _account, uint256 _ulPrice, uint256 _size, uint256 _leverage) internal {
//        // 0. Get the storage slot of the position
//        PositionData storage positionData = read(_position);
//
//        // 1. Validate the params & position
//        require(_size > 0, "Size must be greater than 0");
//        require(_ulPrice > 0, "Price must be greater than 0");
//        require(_leverage > MIN_LEVERAGE, "Leverage must be greater than 1.01");
//        require(_leverage < MAX_LEVERAGE, "Leverage must be less than 500");
//        require(_ulPrice < 1e36, "Price must be less than 10**28");
//        require(_size < 1e36, "Size must be less than 10**28");
//        require(_leverage < 1000, "Leverage must be less than 1000");
//        require(positionData.size == 0, "Position already opened");
//
//        // 2. Update the position
//        positionData.openUlPrice = uint96(_ulPrice);
//        positionData.size = uint96(_size);
//        positionData.leverage = uint32(_leverage);
//    }
//}
