# MultiSig Wallet Smart Contract

## Description
This project implements a Multi-Signature Wallet smart contract on Ethereum using Solidity.  
It requires multiple owners to approve a transaction before it can be executed, improving security in decentralized fund management.

---

## Features
- Multi-owner wallet
- Transaction submission
- Transaction confirmation by owners
- Revoking confirmations before execution
- Execution after reaching required approvals

---

## How it works

1. An owner submits a transaction
2. Other owners confirm the transaction
3. When confirmations reach the required threshold, the transaction can be executed
4. Owners can revoke their confirmation before execution

---

## Contract Functions

- `submitTransaction(to, value, data)` – propose a transaction  
- `confirmTransaction(txId)` – confirm a transaction  
- `revokeConfirmation(txId)` – revoke confirmation  
- `executeTransaction(txId)` – execute transaction after threshold  

---

## Security Features
- Only owners can interact with the contract
- Transactions require multiple confirmations
- Prevents unauthorized execution
- Prevents duplicate confirmations

---

## Testing
Tests were written using Hardhat and Chai.

Coverage:
- Deployment
- Transaction submission
- Confirmation logic
- Execution after threshold
- Revocation of confirmations
- Negative cases (reverts)

Run tests:

npx hardhat test

## Tech Stack
- Solidity ^0.8.x
- Hardhat
- Ethers.js
- Chai