// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DataIncentive {
    address payable public dataProvider;
    address payable public dataConsumer;
    uint public incentiveAmount;
    enum State { Created, Paid }
    State public state;

    constructor(address payable _dataProvider, address payable _dataConsumer, uint _incentiveAmount) {
        dataProvider = _dataProvider;
        dataConsumer = _dataConsumer;
        incentiveAmount = _incentiveAmount;
        state = State.Created;
    }

    function payIncentive() public payable {
        require(msg.sender == dataConsumer && state == State.Created, "State or access error");
        require(msg.value == incentiveAmount, "Incorrect incentive amount");
        dataProvider.transfer(msg.value);
        state = State.Paid;
    }

    function getRefund() public {
        require(msg.sender == dataProvider && state == State.Created, "State or access error");
        dataConsumer.transfer(incentiveAmount);
        state = State.Paid;
    }
}
