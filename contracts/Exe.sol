// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ILooksRare.sol";
import "forge-std/console.sol";
import "../lib/solmate/src/tokens/ERC721.sol";

// Wrapped Ether
interface IWETH {
    /// @notice Deposit ETH to WETH
    function deposit() external payable;

    /// @notice WETH balance
    function balanceOf(address holder) external returns (uint256);

    /// @notice ERC20 Spend approval
    function approve(address spender, uint256 amount) external returns (bool);

    /// @notice ERC20 transferFrom
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract Exe {
    address user;
    address WETH_Addr = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address BAYC_Addr = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    IWETH wETH = IWETH(WETH_Addr);
    ILooksRareExchange exchange;

    constructor(address exchangeAddr) {
        user = msg.sender;
        exchange = ILooksRareExchange(exchangeAddr);
        wETH.approve(address(exchange), type(uint256).max);
        ERC721(BAYC_Addr).setApprovalForAll(address(exchange), true);
    }

    function gogo(OrderTypes.MakerOrder calldata sellOrder) external {
        wETH.deposit{value: address(this).balance}();
        console.log(wETH.balanceOf(address(this)));
        OrderTypes.TakerOrder memory takerBid = OrderTypes.TakerOrder({
            isOrderAsk: false,
            taker: address(this),
            price: sellOrder.price,
            tokenId: sellOrder.tokenId,
            minPercentageToAsk: sellOrder.minPercentageToAsk,
            params: ""
        });
        exchange.matchAskWithTakerBidUsingETHAndWETH(takerBid, sellOrder);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public returns (bytes4) {
        console.log("Received token");
        return 0x150b7a02;
    }

    receive() external payable {}
}
