const path = require('path')
const fs = require('fs-extra')
const Web3 = require('web3')
const dotenv = require('dotenv')
dotenv.config()

const PUBLICK_KEY = process.env.PUBLICK_KEY
const PRIVATE_KEY = process.env.PRIVATE_KEY
const INFURA_PROJECT_ID = process.env.INFURA_PROJECT_ID
const CREDIT_DELEGATION_ADDRESS = process.env.CREDIT_DELEGATION_ADDRESS
const KOVAN_DAI_ADDRESS = '0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD'

const web3 = new Web3(new Web3.providers.HttpProvider(`https://kovan.infura.io/v3/${INFURA_PROJECT_ID}`))
const constractJsonPath = path.resolve(__dirname, '../', 'build/contracts', 'CreditDelegation.json')
const constractJson = JSON.parse(fs.readFileSync(constractJsonPath))
const abi = constractJson.abi
const bytecode = constractJson.bytecode

async function testCreditDelegation() {

  const creditDelegationInstance = new web3.eth.Contract(abi, CREDIT_DELEGATION_ADDRESS, { from: '0xfe3b557e8fb62b89f4916b721be55ceb828dbd73' })

  console.log(PUBLICK_KEY)

  await creditDelegationInstance.methods.depositCollateral(KOVAN_DAI_ADDRESS, 1, true).send({ from: '0xfe3b557e8fb62b89f4916b721be55ceb828dbd73' })

  // console.log("Creating contract...")
  // const superTokenOptions = {
  //   from: besu.member1.publicKey,
  //   data: bytecode,
  //   gasPrice: web3.utils.numberToHex(0),
  //   gasLimit: web3.utils.numberToHex(10000000),
  //   nonce
  // }

  // // Signed transaction
  // const transactionSigned = await web3.eth.accounts.signTransaction(superTokenOptions, besu.member1.privateKey)
  // // Send transaction
  // const contractSigned = await web3.eth.sendSignedTransaction(transactionSigned.rawTransaction)
  // // Get contract Address
  // const transactionReceipt = await web3.eth.getTransactionReceipt(contractSigned.transactionHash, besu.member1.publicKey)
  // const address = transactionReceipt.contractAddress
  // console.log(address)
}

async function main() {
  await testCreditDelegation()
}

if (require.main === module) {
  main()
}

module.exports = exports = main
