const InkaPancakeSwapProvider = artifacts.require("InkaPancakeSwapProvider");

// const WBNB_TESTNET = "0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd"
// const TESTNET_PANCAKESWAP_FACTORY = "0xd417A0A4b65D24f5eBD0898d9028D92E3592afCC"

const WBNB_MAINNET = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c";
const MAINNET_PANCAKE_FACTORY = "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73";


module.exports = function (deployer) {
  deployer.deploy(InkaPancakeSwapProvider, WBNB_MAINNET, MAINNET_PANCAKE_FACTORY);
};
