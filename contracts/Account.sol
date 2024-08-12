// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BaseApp} from "./BaseApp.sol";
import {IAccount} from "@account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "@account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "@account-abstraction/contracts/core/Helpers.sol";
import {IEntryPoint} from "@account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Account is
    IAccount,
    Initializable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable,
    BaseApp
{
    error Account_CallFailed(bytes);

    IEntryPoint private entryPoint;

    modifier isEntryPoint() {
        if (msg.sender != address(entryPoint)) {
            revert(_initError(ERROR_UNAUTHORIZED_ACCESS));
        }
        _;
    }

    modifier isEntryPointOrOwner() {
        if (
            msg.sender != address(entryPoint) &&
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender) != true
        ) {
            revert(_initError(ERROR_UNAUTHORIZED_ACCESS));
        }
        _;
    }

    function initialize(
        address _admin,
        address _entryPoint
    ) public initializer {
        __AccessControl_init();
        init_base_app(_admin);
        _grantRole(MODERATOR_ROLE, msg.sender);
        entryPoint = IEntryPoint(_entryPoint);
    }

    receive() external payable {}
    fallback() external payable {}

    function validateUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external isEntryPoint returns (uint256 validationData) {
        validationData = _validateSignature(userOp, userOpHash);
        _payPreFund(missingAccountFunds);
    }

    // EIP-191 version of the signed hash
    function _validateSignature(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash
    ) internal view returns (uint256 validationData) {
        bytes32 ethSignedMsgHash = MessageHashUtils.toEthSignedMessageHash(
            userOpHash
        );
        address signer = ECDSA.recover(ethSignedMsgHash, userOp.signature);
        if (hasRole(DEFAULT_ADMIN_ROLE, signer) != true) {
            return SIG_VALIDATION_FAILED;
        }
        return SIG_VALIDATION_SUCCESS;
    }

    function execute(
        address destination,
        uint256 value,
        bytes calldata functionData
    ) external isEntryPointOrOwner {
        (bool success, bytes memory result) = destination.call{value: value}(
            functionData
        );
        if (!success) {
            revert(_initError(string(result)));
        }
    }

    function _payPreFund(uint256 missingAccountFunds) internal {
        if (missingAccountFunds != 0) {
            (bool success, ) = payable(msg.sender).call{
                value: missingAccountFunds,
                gas: type(uint256).max
            }("");
            (success);
        }
    }

    function getEntryPoint() external view returns (address) {
        return address(entryPoint);
    }
}
