// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {ERC1967Utils} from "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {UUPSUpgradeable} from "lib/openzeppelin-contracts/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "lib/openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";

contract UpgradeManager is Initializable, UUPSUpgradeable, Ownable {
    address[] public versionHistory;
    
    uint256 public currentVersionIndex;
    
    uint256[50] private __gap;
    
 
    event VersionDeployed(address indexed implementation, uint256 version);
    
    event VersionSwitched(address indexed newImplementation, uint256 newVersion, bool isRollback);
    
    constructor() Ownable(msg.sender) {}
    

    function initialize(address initialOwner) public initializer {
        _transferOwnership(initialOwner);
        
        _registerImplementation(ERC1967Utils.getImplementation());
    }
    
    function upgradeTo(address newImplementation) external onlyOwner {
        upgradeToAndCall(newImplementation, "");
    }
    

    function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual override onlyProxy {
        require(newImplementation != address(0), "Invalid implementation address");
        
        _registerImplementation(newImplementation);
        
        _authorizeUpgrade(newImplementation);
        ERC1967Utils.upgradeToAndCall(newImplementation, data);
        
        emit VersionSwitched(newImplementation, versionHistory.length - 1, false);
    }
    

    function rollbackTo(uint256 versionIndex) external onlyOwner {
        require(versionIndex < versionHistory.length, "Version index out of bounds");
        require(versionIndex != currentVersionIndex, "Cannot rollback to current version");
        
        address implementationToRollbackTo = versionHistory[versionIndex];
        currentVersionIndex = versionIndex;
        
        _authorizeUpgrade(implementationToRollbackTo);
        ERC1967Utils.upgradeToAndCall(implementationToRollbackTo, "");
        
        emit VersionSwitched(implementationToRollbackTo, versionIndex, true);
    }
    

    function _registerImplementation(address implementation) private {
        versionHistory.push(implementation);
        currentVersionIndex = versionHistory.length - 1;
        
        emit VersionDeployed(implementation, versionHistory.length - 1);
    }
    

    function getCurrentImplementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }
    

    function getVersionCount() external view returns (uint256) {
        return versionHistory.length;
    }
    

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
} 