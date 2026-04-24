// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length);

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0
        }));
    }

    function confirmTransaction(uint _txId) public onlyOwner {
        Transaction storage txn = transactions[_txId];

        require(!txn.executed, "Already executed");
        require(!confirmations[_txId][msg.sender], "Already confirmed");

        confirmations[_txId][msg.sender] = true;
        txn.numConfirmations++;
    }

    function revokeConfirmation(uint txIndex) public onlyOwner {
    Transaction storage transaction = transactions[txIndex];

    require(!transaction.executed, "Transaction already executed");
    require(confirmations[txIndex][msg.sender], "Transaction not confirmed");

    // убираем подтверждение
    transaction.numConfirmations -= 1;
    confirmations[txIndex][msg.sender] = false;

    emit RevokeConfirmation(msg.sender, txIndex);
}

    function executeTransaction(uint _txId) public onlyOwner {
        Transaction storage txn = transactions[_txId];

        require(!txn.executed, "Already executed");
        require(txn.numConfirmations >= required, "Not enough confirmations");

        txn.executed = true;

        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        require(success, "Tx failed");
    }


}