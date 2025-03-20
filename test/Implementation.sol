// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {UpgradeManager} from "../src/UpgradeManager.sol";

/**
 * @title Implementation
 * @dev A sample implementation contract that extends the version control system
 */
contract Implementation is UpgradeManager {
    	string public currentMessage;
    	uint256 public currentValue;

			event MessageChanged(string previousMessage, string updatedMessage);
			event ValueChanged(uint256 previousValue, uint256 updatedValue);

			/**
			 * @dev Updates the stored message
			 * @param updatedMessage The new message to store
			 */
			function updateMessage(string memory updatedMessage) external onlyOwner {
					string memory previousMessage = currentMessage;
					currentMessage = updatedMessage;
					emit MessageChanged(previousMessage, updatedMessage);
			}

			/**
			 * @dev Updates the stored value
			 * @param updatedValue The new value to store
			 */
			function updateValue(uint256 updatedValue) external onlyOwner {
					uint256 previousValue = currentValue;
					currentValue = updatedValue;
					emit ValueChanged(previousValue, updatedValue);
			}
} 