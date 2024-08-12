// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

struct User {
    string username;
    string name;
    address payable wallet;
    string payId;
    string email;
    uint256 createdAt;
    uint256 updatedAt;
}
