// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

enum RequestStatus {
    Pending,
    Rejected,
    Fulfilled
}

enum RequestType {
    Wallet,
    Email
}

struct RequestPayment {
    address sender;
    address recipient;
    address token;
    uint256 amount;
    uint256 fee;
    bytes email;
    string remark;
    uint256 createdAt;
    uint256 expiresAt;
    RequestType requestType;
    RequestStatus status;
    bool isRequesting;
    bytes paymentCode;
}
