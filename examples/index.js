const Web3 = require('web3');
const ethers = require('ethers');


const provider = new Web3(new Web3.providers.HttpProvider('https://data-seed-prebsc-1-s1.binance.org:8545'));

const abi = [
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_wbnb",
        "type": "address"
      },
      {
        "internalType": "address",
        "name": "_factory",
        "type": "address"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "number",
        "type": "uint256"
      }
    ],
    "name": "Debug",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "amountOut",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "fee",
        "type": "uint256"
      }
    ],
    "name": "InkaSwapOperation",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "previousOwner",
        "type": "address"
      },
      {
        "indexed": true,
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "OwnershipTransferred",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "FEE_DENOMINATOR",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "WBNB",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "pancakeFactory",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "providerFee",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function",
    "constant": true
  },
  {
    "inputs": [],
    "name": "renounceOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "stateMutability": "payable",
    "type": "receive",
    "payable": true
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "amountOutMin",
        "type": "uint256"
      },
      {
        "internalType": "address[]",
        "name": "path",
        "type": "address[]"
      },
      {
        "internalType": "address",
        "name": "to",
        "type": "address"
      },
      {
        "internalType": "uint256",
        "name": "deadline",
        "type": "uint256"
      }
    ],
    "name": "swapBNBForTokenSupportingFee",
    "outputs": [],
    "stateMutability": "payable",
    "type": "function",
    "payable": true
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "token",
        "type": "address"
      }
    ],
    "name": "withdraw",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_fee",
        "type": "uint256"
      }
    ],
    "name": "setFee",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_factory",
        "type": "address"
      }
    ],
    "name": "setPancakeFactory",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "_wbnb",
        "type": "address"
      }
    ],
    "name": "setWBNB",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  }
];

const address = '0xCD1a49064887e25f8741aA43E1fb2b4852D08181'

const contract = new provider.eth.Contract(abi, address);

let mnemonic = "mistake rural cruise struggle pond soft until own field bonus false patch";
let mnemonicWallet = ethers.Wallet.fromMnemonic(mnemonic);
console.log(mnemonicWallet.privateKey);

// const r = provider.eth.accounts.wallet.add({
//     privateKey: '0x2802347833567203134ba01ea8aa178c7278279f9cc6a09cc7c3399ac44e7dbe',
//     address: '0x6e651F37c0644AA0dE9AF4fb0FE69eBfC9cAD485'
// })
// contract.methods.swapBNBForTokenSupportingFee(
//   "30000000000000000000", 
//   ["0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd", "0x16227D60f7a0e586C66B005219dfc887D13C9531"], 
//   "0x6e651F37c0644AA0dE9AF4fb0FE69eBfC9cAD485", 
//   Math.floor(Date.now() / 1000) + 60 * 20
// ).send({
//   from: "0x6e651F37c0644AA0dE9AF4fb0FE69eBfC9cAD485",
//   gas: '260000',
//   gasPrice: Web3.utils.toWei('21', 'gwei'),
//   value: Web3.utils.toWei('0.086304673077633939')
// }).on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
//   console.log(error, receipt)
// })

