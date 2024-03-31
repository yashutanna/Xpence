// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Expenses {
    struct Expense {
        uint expenseId;
        uint amount;
        address token;
    }

    struct Income {
        uint incomeId;
        uint expenseId;
        uint amount;
        address token;
    }

    event NewExpense(address creditor, uint expenseId);
    event NewIncome(address debtor, uint incomeId);

    uint public expenseIndex;

    mapping(address => uint) public participantIncomesIds;
    mapping(address => bool) public isParticipant;

    mapping(address => Expense[]) public expensesByParticipant;
    mapping(address => Income[]) public incomesByParticipants;
    mapping(uint => Expense) public expensesByExpenseId;
    mapping(address => mapping(uint => Income)) public participantIncomeByIncomeId;
    mapping(address => mapping(address => Income[])) public participantIncomesByAsset;

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

    function addExpenseSimple(address _creditor, uint _amount, address _asset, address[] memory _debtors) external onlyParticipant {
        checkDebtors(_debtors);
        uint expenseId = expenseIndex++;
        Expense memory expense = Expense(expenseId, _amount, _asset);
        
        expensesByExpenseId[expenseId] = expense;
        expensesByParticipant[_creditor].push(expense);

        for(uint i = 0; i < _debtors.length; i++){
            uint participantIncomeId = participantIncomesIds[_debtors[i]]++;
            Income memory income = Income(participantIncomeId, expenseId, _amount/_debtors.length, _asset);
            incomesByParticipants[_debtors[i]].push(income);
            participantIncomeByIncomeId[_creditor][participantIncomeId] = income;
            participantIncomesByAsset[_creditor][_asset].push(income);
        }
    }

    function listExpenses(address _participant) external view returns (Expense[] memory) {
        return expensesByParticipant[_participant];
    }

    function listIncomes(address _participant) external view returns (Income[] memory) {
        return incomesByParticipants[_participant];
    }

    function listIncomes(address _participant, address _asset) external view returns (Income[] memory) {
        return participantIncomesByAsset[_participant][_asset];
    }

    function getIncome(address _participant, uint incomeId) external view returns (Income memory) {
        return participantIncomeByIncomeId[_participant][incomeId];
    }

}