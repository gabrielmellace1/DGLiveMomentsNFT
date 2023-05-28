// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./EIP712MetaTransaction.sol";

import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract DGLiveMoments is
    ERC721,
    ERC721URIStorage,
    ERC721Burnable,
    ERC2981,
    Ownable,
    EIP712MetaTransaction
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) EIP712Base("DGLiveMoments", "v1.0") {
        address sender = msgSender();

        _setDefaultRoyalty(sender, 0);
        //_registerInterface(0x2a55205a);
        _setApprovalForAll(
            sender,
            0x2D6d77D4D7CBF9be50244B52f9bdF87FaD1B3Ad0,
            true
        ); // Change Address?
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC721, ERC2981, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function safeMint(string memory uri) external {
        address creator = msgSender();
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(creator, tokenId);
        _setTokenURI(tokenId, uri);
        _setTokenRoyalty(tokenId, creator, 500);
        emit MintedNFT(creator, tokenId, uri, block.timestamp);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
        emit BurnedNFT(tokenId, msgSender());
    }

    function burnNFT(uint256 tokenId) external onlyOwner {
        address owner = ownerOf(tokenId);
        require(
            owner == msgSender(),
            "Only the owner of NFT can transfer or burn it"
        );

        _burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    event MintedNFT(
        address creator,
        uint256 tokenId,
        string uri,
        uint256 timestamp
    );

    event BurnedNFT(uint256 tokenId, address sender);
}
