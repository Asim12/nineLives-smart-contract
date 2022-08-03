//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NineLives is ERC721A, Ownable { 
    uint256 public immutable maxSupply;
    uint256 public reservedSupply;
    uint public publicMintLimitPerWallet;
    mapping(address => ReservedAddress) public reservedNFTAddresses;
    mapping(address => uint256) public publicMintCounterPerWallet;
    uint256 public publicMintCount;
    string public baseURI;
    string private placeholderURI;
    bool public isMetadataRevealed;
    uint public mintStartTime;

    struct ReservedAddress{
        uint mintLimit;
        uint mintedCount;
    }
    
    constructor(
        string memory name, 
        string memory symbol, 
        uint256 _maxSupply, 
        uint256 _publicLimitPerWallet, 
        address[] memory _reservedAddress, 
        uint256 [] memory _reservedWalletLimit, 
        string memory _placeholderURI,
        uint256 _mintStartTime
        ) ERC721A(name, symbol){
        require(_reservedAddress.length == 3 && _reservedWalletLimit.length == 3, "Only three addresses can be set as reserved addresses");
        
        for(uint index=0; index < _reservedAddress.length; index++){
            reservedNFTAddresses[_reservedAddress[index]].mintLimit = _reservedWalletLimit[index];
            reservedSupply += _reservedWalletLimit[index];
        }
        require(_maxSupply > reservedSupply, "Max supply should be greater than reserved supply");

        maxSupply                   =   _maxSupply;
        publicMintLimitPerWallet    =   _publicLimitPerWallet;
        placeholderURI              =   _placeholderURI;
        mintStartTime = _mintStartTime;
    }

    function setBaseURI(string memory _baseURI) external onlyOwner {
        require(bytes(_baseURI).length > 0, "baseURI cannot be empty");
        baseURI = _baseURI;
    }

    function setMintStartTime(uint256 _mintStartTime) external onlyOwner {
        mintStartTime = _mintStartTime;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require( _exists(tokenId), "URI query for nonexistent token" );
        return (isMetadataRevealed == true) ? string(abi.encodePacked(baseURI, Strings.toString(tokenId),".json")) : placeholderURI;
    }

    function revealMetadata() external onlyOwner{
        require(isMetadataRevealed == false, "Metadata already revelaed");
        isMetadataRevealed = true;
    }

    function mintNFT(uint256 quantity) external {
        require(mintStartTime < block.timestamp, "Mint start time not yet reached.");
        require(maxSupply >= (totalSupply() + quantity), "You can't mint more than maximum supply");
        require((maxSupply - reservedSupply) >= (publicMintCount + quantity) , "Limit for public mint has reached");
        require(publicMintLimitPerWallet >= (publicMintCounterPerWallet[msg.sender] + quantity), "You exceeded your limit to mint per wallet address");
        publicMintCounterPerWallet[msg.sender] += quantity;
        publicMintCount += quantity;
        _safeMint(msg.sender, quantity);
    }

    function mintReservedTokens(uint256 quantity) external {
        require(maxSupply >= (totalSupply() + quantity), "You can't mint more than maximum supply");
        require(reservedNFTAddresses[msg.sender].mintLimit > 0, "You are not authorized to call this function");
        uint availableTokensToMintForSender = reservedNFTAddresses[msg.sender].mintLimit - reservedNFTAddresses[msg.sender].mintedCount;
        require(quantity <= availableTokensToMintForSender, 
        (availableTokensToMintForSender == 0) ? "Mint limit is already reached" : 
            string(abi.encodePacked("You can mint ", Strings.toString(availableTokensToMintForSender), " more tokens only"))
        );
        reservedNFTAddresses[msg.sender].mintedCount += quantity;
        
        _safeMint(msg.sender, quantity);
    } 

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }
}