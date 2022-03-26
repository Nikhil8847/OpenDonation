//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Organization.sol";

contract OrganizationFactory {
    Organization[] public organizations;
    address owner;
    uint256 numberOfRequests;
    constructor() {
        owner = msg.sender;
    }

    event OrganizationAdded(
        address indexed sender,
        Organization organization,
        string organizationName,
        string organizationDescription
    );

    function addOrganization(
        string memory _organizationName,
        string memory _organizationDescription,
        uint256 _minimumContribution
    ) public {
        Organization organization = new Organization(
            msg.sender,
            _organizationName,
            _organizationDescription,
            _minimumContribution
        );
        organizations.push(organization);
        emit OrganizationAdded(
            msg.sender,
            organization,
            _organizationName,
            _organizationDescription
        );
    }

    function getOrganizationDetails(Organization _organization)
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            address
        )
    {
        for (
            uint256 organizationIndex = 0;
            organizationIndex < organizations.length;
            organizationIndex++
        ) {
            if (organizations[organizationIndex] == _organization) {
                return (
                    _organization.organizationName(),
                    _organization.organizationDescription(),
                    _organization.minimumDonation(),
                    address(_organization)
                );
            }
        }
        string memory tempName = "";
        string memory tempDescription = "";
        uint256 tempDonation = 0;
        address tempAddress;
        return (tempName, tempDescription, tempDonation, tempAddress);
        // return ("", "", -1);
    }

    // Request of approval for spending money from smart contract
    // The request needs to be sent by a manager of an organization
    function request() external returns (bool, Organization) {
        for (
            uint256 organizationIndex = 0;
            organizationIndex < organizations.length;
            organizationIndex++
        ) {
            if (
                organizations[organizationIndex].organizationManager() ==
                msg.sender
            ) {
                return (true, organizations[organizationIndex]);
            }
        }
    }

    function approval(uint256 _amount) external {
        
    }
}
