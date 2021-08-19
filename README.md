<p align="center">
  <a href="http://inka.finance/" target="blank"><img src="./2.svg" width="200" alt="Inka Logo" /></a>
</p>
<p align="center">The most friendly DeFi wallet and aggregator.</p>

## Table of contents

- [Description](#description)
- [How it works](#how-it-works)
- [How to run](#how-to-run)

## Description

Compound is an algorithmic, autonomous interest rate protocol built for developers to unlock a universe of open financial applications. Inka wallet integrates with the Compound service through smart contracts in the Solidity language, which allows you to have easy access to add liquidity to the service.

<p>A smart contract for using the Compound service takes a commission that is charged to the Inka wallet.</p>

## How it works

<p align="center">
<img src="./inka_dig.png" alt="Inka Diagrams" />
</p>

<p>Smart contract InkaPancakeSwapProvider is a special layer for integration with the PancakeSwap service. This layer provides easier access to perform operations on the service.</p>

## How to run

When developing a smart contract, the Truffle framework was used to start the deployment process, you need to set up environment variables and install the necessary libraries

<p>ENVIRONMENT variables:</p>

* INFURA_KEY
* MNEMONIC

```
$ npm install

$ truffle compile

$ truffle migrate --network mainnet
```
