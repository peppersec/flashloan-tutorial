# DyDx flashloan tutorial

## Install 
1. `npm i`

## Deploy
1. `cp .env.example .env`
2. Specify `PRIVATE_KEY` and `GAS_PRICE` in the `.env` file
3. `npx truffle migrate --network mainnet --reset`
4. Send a tiny amount of the token you want to borrow to the smart contract. E.g. if you borrow WETH the `FlashloanTaker` has to have 1 wei (one wrapped wei) on the balance.

## To play in remix
1. `npm run flat`
2. Copy content from the `FlashloanTaker.flat.sol` file to the Remix.
3. Remove the second `pragma experimental ABIEncoderV2;`
4. Use "At Address" feature to interact with the contract.

## Other flashloan providers
1. [aave](https://github.com/aave/flashloan-box/blob/master/contracts/Flashloan.sol)

## Use cases
1. Refinancing. Refinance your interest to a lower interest in another lending protocol. Taking flash loan from Aave in Dai, closing a CDP by sending the Dai to the CDP, taking the ETH which was as a collateral to Compound (whichever has better interest rate for borrowers)
2. Closing CDP. The same as above but just closing the CDP without any DAI.
3. [Arbitrage](https://etherscan.io/tx/0x7b67d25e479c363c3bed6fe03fc15e7279a30f9857771b7b2539612c3dc6cf30). 