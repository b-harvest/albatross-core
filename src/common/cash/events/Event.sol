//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

library CashEvent {
    event DepositCash(address _from, address _cashAddress, uint256 _mintAmount);

    event WithdrawCash(address _to, address _cashAddress, uint256 _burnAmount);
}
