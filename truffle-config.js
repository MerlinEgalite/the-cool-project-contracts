const HDWalletProvider = require("@truffle/hdwallet-provider")
const dotenv = require('dotenv')
dotenv.config({ path: '../.env' })

const PRIVATE_KEY = process.env.PRIVATE_KEY
const INFURA_PROJECT_ID = process.env.INFURA_PROJECT_ID

module.exports = {
  networks: {
    ganache: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*'
    },
    kovan: {
      provider: () => new HDWalletProvider(PRIVATE_KEY, `https://kovan.infura.io/v3/${INFURA_PROJECT_ID}`),
      network_id: '*'
    }
  },
  compilers: {
    solc: {
      version: "0.6.12",
    },
  },
}
