// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract CampaignNFT721 is ERC721Upgradeable {
    event TokensCreated(address _to, uint256 _tokenId);

    event MakeMint(
        address _to,
        uint256 _price,
        uint256 _totalPrice,
        uint256 _platformFee,
        address _payToken,
        uint256 _discount
    );
    ///
    ///             EXTERNAL USING
    ///
    using Counters for Counters.Counter;
    // Address will receive fee from mint
    address private feeAddress;

    // campaign creator
    address private ownerAddress;

    // Address sign signature from backend
    // address private signer;

    address payToken;
    // tokenURI of NFTs
    string private baseURI;
    // Counter for tokenId
    Counters.Counter internal tokenIdCounter;

    // total supply of this campaign
    uint256 private totalSupply;
    uint256 private totalMinted;

    // price of each mint action
    uint256 private price;

    // Duration of the campaign
    uint256 private campaignStartTime;
    uint256 private campaignEndTime;

    /// @notice Initialize new campaign
    /// @dev Initialize new campaign
    function initialize(
        string memory _tokenUri,
        address _payToken,
        string memory _name,
        string memory _symbol,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _price,
        uint256 _supply,
        address _feeAddress
    )
        public
        // address _signer
        initializer
    {
        __ERC721_init(_name, _symbol);
        feeAddress = _feeAddress;
        payToken = _payToken;
        baseURI = _tokenUri;

        totalSupply = _supply;

        price = _price;
        campaignStartTime = _startTime;
        campaignEndTime = _endTime;
        ownerAddress = tx.origin;
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    baseURI,
                    "/",
                    Strings.toHexString(uint256(uint160(address(this))), 20),
                    "/",
                    Strings.toString(_tokenId),
                    ".json"
                )
            );
    }

    /// @notice mint new items
    /// @dev mint NFTs to an address
    function makeMintAction(
        uint256 _platformFee,
        uint256 _amount,
        uint256 _discount
    ) external payable {
        require(totalMinted + _amount <= totalSupply, "NFT out of stock");

        payable(feeAddress).transfer(_platformFee);

        uint256 totalPrice = price * _amount - _discount;

        if (payToken == address(0x0)) {
            payable(ownerAddress).transfer(totalPrice);
        } else {
            require(
                IERC20(payToken).balanceOf(msg.sender) > totalPrice,
                "User needs to hold enough token to buy this token"
            );
            IERC20(payToken).transferFrom(msg.sender, ownerAddress, totalPrice);
        }

        for (uint i = 0; i < _amount; i++) {
            mint();
        }

        emit MakeMint(
            msg.sender,
            price,
            totalPrice,
            _platformFee,
            payToken,
            _discount
        );
    }

    function mint() internal {
        uint256 id = tokenIdCounter.current();
        _mint(msg.sender, id);
        totalMinted++;
        tokenIdCounter.increment();

        emit TokensCreated(msg.sender, id);
    }
}
