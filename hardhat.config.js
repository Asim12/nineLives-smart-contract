/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();

const {BSC_API_URL, GR_API_URL, MN_API_URL, RB_API_URL, MN_PRIVATE_KEY_OWNER, RO_API_URL, RO_PRIVATE_KEY_OWNER, RB_PRIVATE_KEY_OWNER } = process.env;
module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {},
    mumbai: {
      url: MN_API_URL,
      accounts: [`0x${MN_PRIVATE_KEY_OWNER}`],
    },

    localhost: {
      url: "http://127.0.0.1:7545"
    },
    bsc: {
      url: BSC_API_URL,
      accounts: [`0x${RB_PRIVATE_KEY_OWNER}`],
    },
    rinkeby: {
      url: RB_API_URL,
      accounts: [`0x${RB_PRIVATE_KEY_OWNER}`],
    },
    ropsten: {
      url: RO_API_URL,
      accounts: [`0x${RO_PRIVATE_KEY_OWNER}`],
    },

    goerli: {
      url: GR_API_URL,
      accounts: [`0x${RO_PRIVATE_KEY_OWNER}`]
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
}