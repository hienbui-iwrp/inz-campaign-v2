// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./campaign721.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

contract CampaignFactory {
    ///
    ///         Event Definitions
    ///

    event NewCampaign(
        address campaignAddress,
        string baseURI,
        address payToken,
        string name,
        string symbol,
        uint256 startTime,
        uint256 endTime,
        uint256 price,
        uint256 supply,
        address feeAddress
    );

    // address of the contract implement logic
    address private implementation721;

    // owner's address of campaign
    mapping(address => address) private campaignOwner;

    constructor(address _implementation721) {
        implementation721 = _implementation721;
    }

    /// @notice Create new campaign
    function createCampaign721(
        string memory _tokenUri,
        address _payToken,
        string memory _name,
        string memory _symbol,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _price,
        uint256 _supply,
        address _feeAddress
    ) external {
        address clone = Clones.clone(implementation721);
        CampaignNFT721(clone).initialize(
            _tokenUri,
            _payToken,
            _name,
            _symbol,
            _startTime,
            _endTime,
            _price,
            _supply,
            _feeAddress
        );

        campaignOwner[clone] = msg.sender;
        emit NewCampaign(
            address(clone),
            _tokenUri,
            address(_payToken),
            _name,
            _symbol,
            _startTime,
            _endTime,
            _price,
            _supply,
            _feeAddress
        );
    }
}
