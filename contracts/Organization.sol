//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Organization is Ownable {
    string public organizationName;
    string public organizationDescription;
    address public organizationManager;
    uint256 public minimumDonation;
    uint256 public numberOfRequests;
    address[] public donators;
    mapping(address => bool) IsAlreadyDonator;
    /* TokenToPriceFeed Map (only used when contribute takes different tokens
    into account) */
    mapping(address => address) tokenToPriceFeed;

    constructor(
        address _organizationManager,
        string memory _organizationName,
        string memory _organizationDescription,
        uint256 _minimumDonation
    ) {
        organizationManager = _organizationManager;
        organizationName = _organizationName;
        organizationDescription = _organizationDescription;
        minimumDonation = _minimumDonation;
    }

    function OrganizationDetails()
        public
        view
        returns (
            string memory,
            string memory,
            uint256
        )
    {
        return (organizationName, organizationDescription, minimumDonation);
    }

    function setPriceFeedContract(address _token, address _priceFeed)
        public
        onlyOwner
    {
        tokenToPriceFeed[_token] = _priceFeed;
    }

    // This function accepts the donation only in ether
    function Donate(uint256 _amount) public payable {
        require(
            _amount >= minimumDonation,
            "Donation Amount is less than the minimum Amount"
        );
        // Check if the donator already donated to this organization?
        // If not then insert this donator's address in the "donators" list
        if (IsAlreadyDonator[msg.sender] == false) {
            IsAlreadyDonator[msg.sender] = true;
            donators.push(address(msg.sender));
        }
    }

    /* This function going to accept different token according to
    there values in USD, */

    // function Contribute(address _token, uint256 _amount) external payable {
    //     (uint256 TokenInUSD, uint256 decimals) = getTokenValue(_token);
    // }

    // function getTokenValue(address _token)
    //     public
    //     view
    //     returns (uint256, uint256)
    // {
    //     address priceFeedAddress = tokenToPriceFeed[_token];
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //         priceFeedAddress
    //     );
    //     (, int256 price, , , ) = priceFeed.latestRoundData();
    //     uint256 decimals = uint256(priceFeed.decimals());
    //     return (uint256(price), decimals);
    // }
}
