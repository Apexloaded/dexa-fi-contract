// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

enum TransactionType {
    Deposit,
    Withdraw,
    Transfer,
    FundBill,
    RemiteBill
}

struct Transaction {
    uint256 txId;
    TransactionType txType;
    address payable txFrom;
    address payable txTo;
    uint256 txAmount;
    uint256 txFee;
    uint256 txDate;
    address tokenAddress;
    string remark;
}
