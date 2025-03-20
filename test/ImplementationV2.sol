// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Implementation} from "./Implementation.sol";

/**
 * @title ImplementationV2
 * @dev An upgraded implementation contract with additional functionality
 */
contract ImplementationV2 is Implementation {
    // Additional state variables
    uint256 public lastTimestamp;
    address public lastCaller;

    // Events
    event TimestampChanged(uint256 previousTimestamp, uint256 newTimestamp);

    /**
     * @dev Updates the timestamp to the current block timestamp
     */
    function refreshTimestamp() external {
        uint256 previousTimestamp = lastTimestamp;
        lastTimestamp = block.timestamp;
        lastCaller = msg.sender;
        emit TimestampChanged(previousTimestamp, lastTimestamp);
    }

    /**
     * @dev Retrieves all stored data in a single call
     * @return The current message, value, timestamp, and last caller
     */
    function fetchAllData() external view returns (string memory, uint256, uint256, address) {
        return (currentMessage, currentValue, lastTimestamp, lastCaller);
    }
} 