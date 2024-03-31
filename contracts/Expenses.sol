// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Expenses {
    event NewCredit(address creditor, address asset, uint amount);
    event NewDebit(address debtor, address asset, uint amount);

    struct LedgerEntry {
        uint amount;
        address asset;
        string description;
    }

    struct Ledger {
        LedgerEntry[] debits;
        LedgerEntry[] credits;
    }

    mapping(address => Ledger) private participantLedger;
    mapping(address => bool) public isParticipant;

    modifier onlyParticipant {
        require(isParticipant[msg.sender] == true);
        _;
    }

    constructor(){
        isParticipant[msg.sender] = true;
    }

    function addParticipant(address _participant) external onlyParticipant {
        require(isParticipant[_participant] == false, "address is already a participant");
        isParticipant[_participant] = true;
    }

    function checkDebtors(address[] memory _debtors) internal {
        for(uint i = 0; i < _debtors.length; i++){
            require(isParticipant[_debtors[i]] == true, "debtor is is not a participant");
            isParticipant[_debtors[i]] = true;
        }
    }

    function addCreditSimple(address _creditor, uint _amount, address _asset, address[] memory _debtors, string memory _description) external onlyParticipant {
        checkDebtors(_debtors);
        LedgerEntry memory debit = LedgerEntry(_amount, _asset, _description);
        participantLedger[_creditor].debits.push(debit);
        emit NewCredit(_creditor, _asset, _amount);

        for(uint i = 0; i < _debtors.length; i++){
            LedgerEntry memory credit = LedgerEntry(_amount/_debtors.length, _asset, _description);
            participantLedger[_debtors[i]].credits.push(credit);
            emit NewDebit(_debtors[i], credit.asset, credit.amount);
        }
    }

    function listCredits(address _participant) external view returns (LedgerEntry[] memory) {
        return participantLedger[_participant].credits;
    }

    function listDebits(address _participant) external view returns (LedgerEntry[] memory) {
        return participantLedger[_participant].debits;
    }
}