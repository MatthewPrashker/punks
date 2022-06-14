// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import "solmate/tokens/ERC20.sol";
import "solmate/tokens/ERC721.sol";
import "solmate/tokens/ERC1155.sol";

import "../../contracts/Example.sol";

contract TestExample is Test {
    address internal immutable nftAddr =
        0x2fC722C1c77170A61F17962CC4D039692f033b43; //Milady

    address internal immutable punkVTokenAddr =
        0x269616D549D7e8Eaa82DFb17028d0B212D11232A;

    function setUp() public payable {}

    function testNFTName() public {
        console.log("Examing NFT at", nftAddr);
        ERC721 nft = ERC721(nftAddr);
        console.log(nft.name());
    }

    function testVToken() public {
        ERC20 punkVToken = ERC20(punkVTokenAddr);
        //There will be exactly one punk in the nftx token vault for every vToken in existence.
        console.log(
            "Number of punks inside the vault at this time",
            punkVToken.totalSupply() / (10**18)
        );
    }
}
