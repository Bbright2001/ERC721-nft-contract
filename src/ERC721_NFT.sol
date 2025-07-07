// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ColabNft is ERC721, ERC721URIStorage {
    address owner;

    struct participantInfo{
        bool hasParticipated;
    }
    
   
    uint256 private _nextTokenId = 1;
    string private constant FIXED_TOKEN_URI =
        "https://gateway.pinata.cloud/ipfs/bafkreicqrevo7hw64lw2ymgwkhri4zyno6mfkvvsivpmorazpmoioe7qhi";


     mapping(address => participantInfo) public participants;
     mapping(address => uint256) public addressToToken;

    constructor(address initialOwner) ERC721("Colab BlockChain", "CBK") {
        owner = initialOwner;
    }

    error onlyOwnerAccess();
    error alreadyParticipated();
  


    event OwnershipTransferred(address newOwner);
    event TaskCompleted();

    modifier onlyOwner() {

        if (owner != msg.sender) revert onlyOwnerAccess();
        _;
    }

    function taskParticipation() external {
            participantInfo storage p = participants[msg.sender];
            if(p.hasParticipated) revert  alreadyParticipated();

            p.hasParticipated = true;

            uint256 token_id = _nextTokenId;
            _safeMint(msg.sender, token_id);
            _setTokenURI(token_id, FIXED_TOKEN_URI);   

            addressToToken[msg.sender] = token_id;   

            _nextTokenId++;

             emit TaskCompleted();
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

        emit OwnershipTransferred(_newOwner);
    }

}

