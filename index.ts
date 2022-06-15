import axios from 'axios'
import { BigNumber } from 'ethers'

//LooksRare api information
const baseURL = 'https://api.looksrare.org'
const extensionURL = '/api/v1/orders'

const WETH_Addr = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'

function getBestBid(bidOrders) {}

function getBestAsks(askOrders) {}

async function getOpenOrders(nftAddr) {
  let openBids = []
  let openAsks = []

  const bidRequestParams = {
    isOrderAsk: false,
    collection: nftAddr,
    currency: WETH_Addr,
    status: ['VALID'],
    pagination: {
      first: 150,
    },
    sort: 'NEWEST',
  }

  const askRequestParams = {
    isOrderAsk: true,
    collection: nftAddr,
    currency: WETH_Addr,
    status: ['VALID'],
    pagination: {
      first: 150,
    },
    sort: 'NEWEST',
  }

  await axios
    .get(baseURL.concat(extensionURL), { params: bidRequestParams })
    .then((res) => {
      openBids = res.data.data
    })
    .catch((err) => {
      console.log('Unable to get openBids for', nftAddr)
    })

  await axios
    .get(baseURL.concat(extensionURL), { params: askRequestParams })
    .then((res) => {
      openAsks = res.data.data
    })
    .catch((err) => {
      console.log('Unable to get openAsks for', nftAddr)
    })

  return [openBids, openAsks]
}

async function main() {
  const BAYC_Addr = '0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D'
  const GOBLIN_Addr = '0xbCe3781ae7Ca1a5e050Bd9C4c77369867eBc307e'

  const [openBids, openAsks] = await getOpenOrders(GOBLIN_Addr)
  console.log(openBids[0], openBids[openBids.length - 1])
}

main()
