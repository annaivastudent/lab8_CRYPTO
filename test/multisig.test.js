const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("MultiSigWallet", function () {
  let contract;
  let owners;

  beforeEach(async () => {
    owners = await ethers.getSigners();

    const MultiSig = await ethers.getContractFactory("MultiSigWallet");

    contract = await MultiSig.deploy(
      [owners[0].address, owners[1].address, owners[2].address],
      2
    );

    await contract.waitForDeployment();
  });

  it("should deploy correctly", async () => {
    const required = await contract.required();
    expect(Number(required)).to.equal(2);
  });

  it("should submit transaction", async () => {
    await contract.submitTransaction(owners[1].address, 0, "0x");

    const tx = await contract.transactions(0);

    expect(tx.to).to.equal(owners[1].address);
  });

  it("should confirm transaction", async () => {
    await contract.submitTransaction(owners[1].address, 0, "0x");

    await contract.confirmTransaction(0);

    const tx = await contract.transactions(0);

    expect(Number(tx.numConfirmations)).to.equal(1);
  });

  it("should execute after confirmations", async () => {
    await contract.submitTransaction(owners[1].address, 0, "0x");

    await contract.connect(owners[0]).confirmTransaction(0);
    await contract.connect(owners[1]).confirmTransaction(0);

    await contract.executeTransaction(0);

    const tx = await contract.transactions(0);

    expect(tx.executed).to.equal(true);
  });

  it("should allow owner to revoke confirmation", async () => {
    await contract.submitTransaction(owners[1].address, 0, "0x");

    await contract.connect(owners[0]).confirmTransaction(0);

    await contract.connect(owners[0]).revokeConfirmation(0);

    const tx = await contract.transactions(0);

    expect(Number(tx.numConfirmations)).to.equal(0);
  });

  it("should NOT allow non-confirmed owner to revoke", async () => {
    await contract.submitTransaction(owners[1].address, 0, "0x");

    await expect(
      contract.connect(owners[0]).revokeConfirmation(0)
    ).to.be.revertedWith("Transaction not confirmed");
  });
});