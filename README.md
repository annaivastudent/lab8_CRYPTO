# MultiSig Wallet Smart Contract

## Description

This project implements a Multi-Signature Wallet smart contract on Ethereum using Solidity.
It requires multiple owners to approve a transaction before it can be executed, improving security in decentralized fund management.

---

## Features

* Multi-owner wallet
* Transaction submission
* Transaction confirmation by owners
* Revoking confirmations before execution
* Execution after reaching required confirmations

---

## How it works

1. An owner submits a transaction
2. Other owners confirm the transaction
3. When confirmations reach the required threshold, the transaction can be executed
4. Owners can revoke their confirmation before execution

---

## Security Model

* Only registered owners can interact with the contract
* A transaction requires at least **2 confirmations out of 3 owners**
* Prevents single-point control
* Prevents unauthorized execution of funds
* Prevents duplicate confirmations

---

## Contract Functions

* `submitTransaction(to, value, data)` – propose a transaction
* `confirmTransaction(txId)` – confirm a transaction
* `revokeConfirmation(txId)` – revoke confirmation before execution
* `executeTransaction(txId)` – execute transaction after threshold is reached

---

## Testing

Tests were written using Hardhat and Chai.

Coverage includes:

* Contract deployment
* Transaction submission
* Confirmation logic
* Execution after reaching threshold
* Revocation of confirmations
* Negative cases (reverts and access control)

Run tests:

```bash
npx hardhat test
```

---

## Deployment

```bash
npx hardhat node
npx hardhat run scripts/deploy.js --network localhost
```

---

## Contract Address (local example)

`0x5FbDB2315678afecb367f032d93F642f64180aa3`

---

## Example Usage

```javascript
await contract.submitTransaction(addr, 0, "0x");
await contract.confirmTransaction(0);
await contract.executeTransaction(0);
```

---

## Result

The multi-signature workflow was successfully tested:

* Transaction submitted
* Confirmations collected
* Threshold reached
* Transaction executed

This demonstrates correct enforcement of multi-signature approval before execution.
