// This script can be used to deploy the "Storage" contract using Web3 library.
// Please make sure to compile "./contracts/1_Storage.sol" file before running this script.
// And use Right click -> "Run" from context menu of the file to run the script. Shortcut: Ctrl+Shift+S

import { deploy, } from './web3-lib'

(async () => {
  try {
    // const expensesContract = await deploy('Expenses', [])
    // console.log({ expensesContract: expensesContract.address })

    try {
      const wethToken = await deploy('DummyToken', [
        'Wrapped Ether',
        'WETH',
        '18',
        '10000000000000000000000'// 10,000 WETH
      ])
      console.log({ wethToken: wethToken.address })
    } catch(e){
      console.log(e);
    }

    const usdcToken = await deploy('DummyToken', [
      'USD Coin',
      'USDC',
      '6',
      '1000000000000'// 1,000,000 USDC
    ])
    console.log({ usdcToken: usdcToken.address })

  } catch (e) {
    console.log(e)
  }
})()

/**
 * 
 * 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
 * 
 * 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
 * 
 * 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
 * 
 * USDC Sepolia (Arbitrum) - 0xf3c3351d6bd0098eeb33ca8f830faf2a141ea2e1
 */