// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

import "solmate/tokens/ERC20.sol";
import "solmate/tokens/ERC721.sol";

import "../../contracts/Example.sol";

contract TestExample is Test {
    address internal immutable punkAddr =
        0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;

    function setUp() public payable {}

    function testPunks() public {
        console.log(punkAddr);
        ERC721 punk = ERC721(punkAddr);
        console.log(punk.name());
        //for(uint256 i = 0; i < 4; i++) {
        //  console.log(punk.tokenURI(i));
        //}
    }
}
