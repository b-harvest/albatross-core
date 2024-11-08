// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import {Proxy} from "src/proxy/Proxy.sol";
import {ProxyManager} from "src/proxy/ProxyManager.sol";
import {IProxyFactory} from "src/proxy/interfaces/IProxyFactory.sol";

/**
 * @title ProxyFactory
 * @dev Factory contract for managing and creating proxies,
 *      handling versioning, governance, and developer permissions.
 */
contract ProxyFactory is IProxyFactory {
    // Address of the governance entity
    address public governance;

    // Mapping of whitelisted developers
    mapping(address => bool) public whitelistedDevelopers;

    // Mapping of version identifiers to their respective version information
    mapping(uint48 => VersionInfo) public versions;

    // Address of the proxy manager implementation contract
    address public proxyManagerImpl;

    // Struct to store version information
    struct VersionInfo {
        address newVersionContract;      // Address of the new version's contract
        bool isSuggested;                // Indicates if the version is suggested
        uint48 lastCompatibleVersion;    // The last compatible version ID
    }

    /**
     * @dev Initializes the contract with the first developer and sets the governance to the deployer.
     * @param _firstDeveloper The address of the initial whitelisted developer.
     */
    constructor(address _firstDeveloper) {
        governance = msg.sender;
        whitelistedDevelopers[_firstDeveloper] = true;
        proxyManagerImpl = address(new ProxyManager());
    }

    /**
     * @dev Creates a new proxy for a specific version.
     * @param _big The major version number.
     * @param _medium The minor version number.
     * @param _small The patch version number.
     * @return The address of the created proxy.
     */
    function createProxy(uint16 _big, uint16 _medium, uint16 _small) external returns (address) {
        uint48 version = _encodeVersion(_big, _medium, _small);
        return new Proxy(msg.sender, proxyManagerImpl, versions[version].newVersionContract);
    }

    /**
     * @dev Suggests a new version for the proxy system.
     * @param _big The major version number.
     * @param _medium The minor version number.
     * @param _small The patch version number.
     * @param _newVersionContract The address of the new version's contract.
     * @param _lastCompatibleVersion The last compatible version ID.
     */
    function suggestNewVersion(
        uint16 _big,
        uint16 _medium,
        uint16 _small,
        address _newVersionContract,
        uint48 _lastCompatibleVersion
    ) external {
        require(whitelistedDevelopers[msg.sender], "ProxyFactory: FORBIDDEN");
        uint48 version = _encodeVersion(_big, _medium, _small);
        bool isSuggested = msg.sender == governance;
        versions[version] = VersionInfo(_newVersionContract, isSuggested, _lastCompatibleVersion);
    }

    /**
     * @dev Approves a previously suggested version. Only callable by governance.
     * @param _big The major version number.
     * @param _medium The minor version number.
     * @param _small The patch version number.
     */
    function approveNewVersion(uint16 _big, uint16 _medium, uint16 _small) external {
        require(msg.sender == governance, "ProxyFactory: FORBIDDEN");
        uint48 version = _encodeVersion(_big, _medium, _small);
        versions[version].isSuggested = true;
    }

    /**
     * @dev Sets a new governance address. Only callable by the current governance.
     * @param _governance The new governance address.
     */
    function setGovernance(address _governance) external {
        require(msg.sender == governance, "ProxyFactory: FORBIDDEN");
        governance = _governance;
    }

    /**
     * @dev Allows a developer to be whitelisted. Only callable by governance.
     * @param _developer The address of the developer to whitelist.
     */
    function allowDeveloper(address _developer) external {
        require(msg.sender == governance, "ProxyFactory: FORBIDDEN");
        whitelistedDevelopers[_developer] = true;
    }

    /**
     * @dev Removes a developer from the whitelist. Only callable by governance.
     * @param _developer The address of the developer to remove from the whitelist.
     */
    function disallowDeveloper(address _developer) external {
        require(msg.sender == governance, "ProxyFactory: FORBIDDEN");
        whitelistedDevelopers[_developer] = false;
    }

    /**
     * @dev Retrieves version information for a specific version identifier.
     * @param _big The major version number.
     * @param _medium The minor version number.
     * @param _small The patch version number.
     * @return The version information (newVersionContract, isSuggested, lastCompatibleVersion).
     */
    function getVersionInfo(uint16 _big, uint16 _medium, uint16 _small)
    external
    view
    returns (address, bool, uint48)
    {
        uint48 version = _encodeVersion(_big, _medium, _small);
        VersionInfo memory versionInfo = versions[version];
        return (versionInfo.newVersionContract, versionInfo.isSuggested, versionInfo.lastCompatibleVersion);
    }

    /**
     * @dev Encodes version numbers into a single uint48 identifier.
     * @param _big The major version number.
     * @param _medium The minor version number.
     * @param _small The patch version number.
     * @return The encoded uint48 version identifier.
     */
    function _encodeVersion(uint16 _big, uint16 _medium, uint16 _small) internal pure returns (uint48) {
        return (uint48(_big) << 32) | (uint48(_medium) << 16) | uint48(_small);
    }
}
