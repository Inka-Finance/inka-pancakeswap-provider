require('dotenv').config()

const HDWalletProvider = require('@truffle/hdwallet-provider');
const mnemonicTestnet = process.env.MNEMONIC_TESTNET;
const mnemonicMainnet = process.env.MNEMONIC_MAINNET;

const addressMainnet = process.env.ADDRESS_MAINNET;

const nodeURLTestnet = "https://data-seed-prebsc-1-s1.binance.org:8545";
const nodeURLMainnet = "https://bsc-dataseed1.binance.org:443";
module.exports = {
  networks: {
    bsc_testnet: {
      provider: function () {
        return new HDWalletProvider(mnemonicTestnet, nodeURLTestnet);
      },
      gas: 5000000,
      skipDryRun: true,
      network_id: "*",
    },
    bsc_mainnet: {
      provider: function () {
        return new HDWalletProvider(mnemonicMainnet, nodeURLMainnet);
      },
      from: addressMainnet,
      network_id: "*",
    },
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.6.12",    // Fetch exact version from solc-bin (default: truffle's version)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
       optimizer: {
         enabled: false,
         runs: 200
       },
      }
    }
  }
};
