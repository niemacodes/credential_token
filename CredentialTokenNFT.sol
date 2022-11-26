// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// Dev imports
import "hardhat/console.sol";


contract CredentialTokenNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable  {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // Individual Credential Token Data: 
    // 0 - Garden Bed, 1 - Learn, 2 - Prototype, 3 - Venture
    struct CredentialToken {
        uint256 id; 
        uint256 currentLevel; 
        string credentialTokenURI;
        string cohort; 
    }

    // IPFS URIs for the credential tokens graphics/metadata (Test Data): 
    string venture = "https://ipfs.io/ipfs/Qma6VYzoLRWPNgv16dBm4EEuDVfiaDhRbchuDu6F6SKFvk?filename=venture.png";
    string prototype = "https://ipfs.io/ipfs/QmYSanFMhGg4Xyz4xpYBUUhwbNGbyfwmwZ43qfawUApMhZ?filename=prototype.png";
    string learn = "https://ipfs.io/ipfs/QmRQQTuvquAsA9bkbDtFPA9PHD8xqfp5LReB15rZ1L6XqU?filename=learn.png";
    string base = "https://ipfs.io/ipfs/QmeuARsvCP96xySmZ7XLCwa6XwgVbXEP3hdCbp89qcDVDb?filename=base.png";

    // Emitting updates:
    event CredentialTokenUpdated(uint256 tokenId, string level);

    // Mappings: 
    mapping(uint256 => CredentialToken) public credentialTokens; 
    mapping(address => uint256[]) ownedCredentialTokens;

    // On Construction: Set the Base URI to the default garden bed: 
    constructor() ERC721("Women In Web 3.0 Credential Tokens", "CT") {}

    function safeMint(address to) public onlyOwner{
        // Current counter value will be the minted token's token ID.
        uint256 tokenId = _tokenIdCounter.current();

        // Increment it so next time it's correct when we call .current()
        _tokenIdCounter.increment();

        // Mint the credential token:
        _safeMint(to, tokenId);

        // Set Base URI & level to Garden Bed, & the cohort: 
        setDefaultURI(tokenId);

        console.log("DONE!!! minted token ", tokenId);
    }

    function setDefaultURI(uint256 tokenId) external override {
        
         // Default to the base Garden Bed: 
        string memory defaultUri = base; 
        _setTokenURI(tokenId, defaultUri);

        // Create the Credential Token:
        CredentialToken memory credentialToken;
        credentialToken.id = tokenId;
        credentialToken.currentLevel = 0;
        credentialToken.credentialTokenURI = base;
        credentialToken.cohort = "Metaverse"; 

        // Update Credential Tokens:
        credentialTokens[tokenId] = credentialToken;
    }

    // Updates Token URIs based on the current level: 
    function updateLevel(uint256 tokenId, uint256 level) internal {

        // Get Credential Token: 
        CredentialToken memory credentialToken = credentialTokens[tokenId];

        if (level == 0) {
            console.log("NO CHANGE -> returning!");
            return;
        }

        // 1st Level: Learn
        if (level == 1) {
            // Testing:
            console.log("UPDATING TOKEN URIS WITH ", "learn", level);   

            // Setting the token URI: 
            _setTokenURI(credentialToken.id, learn);

            // Updating the current level & token URI: 
            credentialToken.currentLevel = 1; 
            credentialToken.credentialTokenURI = learn; 
        } 
        
        // 2nd Level: Prototype
        if (level == 2) {
            // Testing:
            console.log("UPDATING TOKEN URIS WITH ", "prototype", level);

            // Setting the token URI: 
            _setTokenURI(credentialToken.id, prototype);  

            // Updating the current level & token URI: 
            credentialToken.currentLevel = 2; 
            credentialToken.credentialTokenURI = prototype; 
        } 
        
        // 3rd Level: Venture
        if (level == 3){
            // Testing:
            console.log(" UPDATING TOKEN URIS WITH ", "venture", level);

            // Setting the token URI: 
            _setTokenURI(credentialToken.id, venture);

            // Updating the current level & token URI: 
            credentialToken.currentLevel = 3; 
            credentialToken.credentialTokenURI = venture; 
        }

        emit CredentialTokenUpdated(credentialToken.id, level);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}