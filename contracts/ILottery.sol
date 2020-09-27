// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

interface ILottery {

    function getName() external view returns(string memory);

    function activate(uint _ticketCost) external;
    
    function getTicketCost() external view returns (uint);

    function buyTicket(string memory _name) external payable;

    function pickWinner() external payable;
}

