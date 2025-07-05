// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ColabNft is ERC721, ERC721URIStorage {
    address owner;
    struct participantInfo{
        bool taskCompleted;
        bool minted;
    }
    

    uint256 private _nextTokenId = 1;
    string private constant FIXED_TOKEN_URI =
        "https://gateway.pinata.cloud/ipfs/bafkreidmfnqopvdqtb2njf6jm4tu3whunm2cmzt4ydyljuht7grg7wpjcq";


     mapping(uint256 => participantInfo) public participantTokenId;

    constructor(address initialOwner) ERC721("Colab BlockChain", "CBK") {
        owner = initialOwner;
    }

    error onlyOwnerAccess();


    event OwnershipTransferred(address newOwner);
    event TaskCompleted();

    modifier onlyOwner(address _initialOwner) {

        if (owner != msg.sender) revert onlyOwnerAccess();
        _;
    }

    function taskParticipation() external {
        require(msg.sender == address(0), "Invalid Participant")
        
    }
        // Function to issue a participation reward with a fixed URI
    function mint() external {
       uint256 token_id = _nextTokenId;
        _safeMint(msg.sender, token_id);
        _setTokenURI(token_id, FIXED_TOKEN_URI);        

        _nextTokenId++;
    }

      function mint_with_uri(address receiver, string memory uri) external {
       uint256 token_id = _nextTokenId;
        _safeMint(receiver, token_id);
        _setTokenURI(token_id, uri);        

        _nextTokenId++;
    }



    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // function that allows for ownership tranfer

    function transferOwner(address _newOwner) internal onlyOwner {
        require(_newOwner != address(0), "invalid Address");
        owner = _newOwner;

        emit OwnershipTransferred(address _newOwner);
    }

}

