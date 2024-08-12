// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

contract BaseApp is
    Initializable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable
{
    /**
     * @notice Roles Variable
     */
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");
    bytes32 public constant GATEWAY_ROLE = keccak256("GATEWAY_ROLE");
    bytes32 public constant BILLPOINT_ROLE = keccak256("BILLPOINT_ROLE");
    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");
    bytes32 public constant ORGANIZATION_ROLE = keccak256("ORGANIZATION_ROLE");

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

    /**
     * @notice Initialize function
     * @param _admin The address of the administrator
     */
    function init_base_app(address _admin) public onlyInitializing {
        __AccessControl_init();
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
    }

    function toLower(string memory str) internal pure returns (string memory) {
        bytes memory data = bytes(str);
        bytes memory lowercaseData = new bytes(data.length);

        for (uint256 i = 0; i < data.length; i++) {
            lowercaseData[i] = _toLower(data[i]);
        }
        return string(lowercaseData);
    }

    function _toLower(bytes1 char) private pure returns (bytes1) {
        if (uint8(char) >= 65 && uint8(char) <= 90) {
            return bytes1(uint8(char) + 32);
        } else {
            return char;
        }
    }

    function _initError(
        string memory error
    ) internal pure returns (string memory) {
        return string.concat("Dexa: ", error);
    }
}
