import hre from 'hardhat'
import { getOpenOrders } from '../looksRare'
import assert from 'assert'

describe('Hardhat Runtime Environment', function () {
  it('should have a config field', function () {
    assert.notEqual(hre.config, undefined)
  })
})

describe('Hardhat Runtime Environment', function () {
  it('basic match', async function () {
    const looksRareExchangeAddr = '0x59728544B08AB483533076417FbBB2fD0B17CE3a'
    const BAYC_Addr = '0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D'
    const Exe = await hre.ethers.getContractFactory('Exe')
    const exe = await Exe.deploy(looksRareExchangeAddr)
    console.log(exe.address)
    const makerAsk = await getOpenOrders(BAYC_Addr).then((res) => {
      return res[1][5]
    })
    //console.log(makerAsk);
    //console.log(makerAsk['price']);

    const makerAskInput = {
      isOrderAsk: true,
      signer: makerAsk['signer'],
      collection: makerAsk['collectionAddress'],
      price: hre.ethers.BigNumber.from(makerAsk['price']),
      tokenId: hre.ethers.BigNumber.from(makerAsk['tokenId']),
      amount: hre.ethers.BigNumber.from(makerAsk['amount']),
      strategy: makerAsk['strategy'],
      currency: makerAsk['currencyAddress'],
      nonce: hre.ethers.BigNumber.from(makerAsk['nonce']),
      startTime: hre.ethers.BigNumber.from(makerAsk['startTime']),
      endTime: hre.ethers.BigNumber.from(makerAsk['endTime']),
      minPercentageToAsk: hre.ethers.BigNumber.from(makerAsk['minPercentageToAsk']),
      params: '0x', //no-bytes
      v: hre.ethers.BigNumber.from(makerAsk['v']),
      r: makerAsk['r'],
      s: makerAsk['s'],
    }
    console.log(makerAskInput)

    const [owner] = await hre.ethers.getSigners()
    await owner.sendTransaction({
      to: exe.address,
      value: hre.ethers.utils.parseEther('1000'), // 1 ether
    })

    const tx = await exe.gogo(makerAskInput)
    //console.log(tx);
  })
})
