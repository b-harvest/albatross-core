//SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

import { Account } from "src/types/CustomTypes.sol";

library AccountError {
    error AuthorizationFailed(Account account, address signer);
}
