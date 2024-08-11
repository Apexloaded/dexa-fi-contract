// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

contract DexaFiBase is
    Initializable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable
{
    /**
     * @notice Error Codes
     */
    string public constant ERROR_INVALID_STRING = "2";
    string public constant ERROR_UNAUTHORIZED_ACCESS = "3";
    string public constant ERROR_DUPLICATE_RESOURCE = "4";
    string public constant ERROR_NOT_FOUND = "5";
    string public constant ERROR_INVALID_PRICE = "6";
    string public constant ERROR_PROCESS_FAILED = "7";
    string public constant ERROR_EXPIRED_RESOURCE = "8";

    function _initError(
        string memory error
    ) internal pure returns (string memory) {
        return string.concat("Dexa: ", error);
    }
}
