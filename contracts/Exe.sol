// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ILooksRare.sol";
import "forge-std/console.sol";
import "../lib/solmate/src/tokens/ERC20.sol";
import "../lib/solmate/src/tokens/ERC721.sol";
import "../lib/solmate/src/tokens/WETH.sol";
import "contracts/Interfaces/INFTX.sol";

contract Exe is IERC3156FlashBorrowerUpgradeable {
    address user;
    address WETH_Addr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    address Punk = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
    address Punkx = 0x269616D549D7e8Eaa82DFb17028d0B212D11232A;
    NftxVault PunkVault = NftxVault(Punkx);

    WETH wETH = WETH(payable(WETH_Addr));

    ILooksRareExchange exchange;
    address internal nftTokenAddr;

    constructor(address exchangeAddr, address _nftTokenAddr) {
        user = msg.sender;
        nftTokenAddr = _nftTokenAddr;
        exchange = ILooksRareExchange(exchangeAddr);

        //approvals
        wETH.approve(address(exchange), type(uint256).max);
        ERC20(Punkx).approve(Punkx, type(uint256).max);
        //ERC721(BAYC_Addr).setApprovalForAll(address(exchange), true);
    }

    function gogo(OrderTypes.MakerOrder calldata sellOrder) external {
        wETH.deposit{value: address(this).balance}(); //convert all ETH to WETH
        console.log(wETH.balanceOf(address(this)));

        console.log("Buying nft", sellOrder.tokenId, "for", sellOrder.price);

        OrderTypes.TakerOrder memory takerBid = OrderTypes.TakerOrder({
            isOrderAsk: false,
            taker: address(this),
            price: sellOrder.price,
            tokenId: sellOrder.tokenId,
            minPercentageToAsk: sellOrder.minPercentageToAsk,
            params: ""
        });
        exchange.matchAskWithTakerBidUsingETHAndWETH(takerBid, sellOrder);

        PunkVault.flashLoan(
            IERC3156FlashBorrowerUpgradeable(address(this)),
            Punkx,
            100 ether,
            ""
        );
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {
        console.log("Received flash loan from NFTX vault");

        console.log(ERC20(Punkx).balanceOf(address(this)));

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    //Necessary to conform to receive under safeTransfer protocol
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public returns (bytes4) {
        console.log(
            "nfts received",
            nftTokenAddr,
            ERC721(nftTokenAddr).balanceOf(address(this))
        );
        return 0x150b7a02;
    }

    receive() external payable {}
}
