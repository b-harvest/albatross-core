// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

/**
 * @title IProxyFactory
 * @dev Interface for the ProxyFactory contract.
 */
interface IProxyFactory {
    struct VersionInfo {
        address newVersionContract;      // Address of the new version's contract
        bool isSuggested;                // Indicates if the version is suggested
        uint48 lastCompatibleVersion;    // The last compatible version ID
    }

    // Events
    event GovernanceChanged(address indexed oldGovernance, address indexed newGovernance);
    event DeveloperWhitelisted(address indexed developer);
    event DeveloperRemoved(address indexed developer);
    event NewVersionSuggested(uint48 indexed version, address indexed newVersionContract, uint48 lastCompatibleVersion);
    event NewVersionApproved(uint48 indexed version);

    // State variables
    function governance() external view returns (address);
    function whitelistedDevelopers(address developer) external view returns (bool);
    function versions(uint48 version) external view returns (VersionInfo memory);
    function proxyManagerImpl() external view returns (address);

    // Functions
    function createProxy(uint16 _big, uint16 _medium, uint16 _small) external returns (address);

    function suggestNewVersion(
        uint16 _big,
        uint16 _medium,
        uint16 _small,
        address _newVersionContract,
        uint48 _lastCompatibleVersion
    ) external;

    function approveNewVersion(uint16 _big, uint16 _medium, uint16 _small) external;

    function setGovernance(address _governance) external;

    function allowDeveloper(address _developer) external;

    function disallowDeveloper(address _developer) external;

    function getVersionInfo(
        uint16 _big,
        uint16 _medium,
        uint16 _small
    ) external view returns (address, bool, uint48);
}
