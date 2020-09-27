// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import { ILottery } from './ILottery.sol';

contract Lottery is ILottery {

    string name;
    uint ticketCost;
    address manager;
    Player winner;
    
    Status currentStatus;

    struct Player {
        string name;
        address wallet;
        uint index;
    }

    mapping (address => Player) players;

    address payable[] playerList;

    event NewPlayer(string player);
    event LotteryFinished(address winner);

    modifier OnlyManager() {
        require(manager == msg.sender, "Only manager allow");
        _;
    }

    enum Status { inactive, isPrepared, isActive, isFinished }

    constructor(string memory _name, address _manager) {
        name = _name;
        manager = _manager; // msg.sender
    }

    function getName() public view override returns(string memory) {
        return name;
    }
    
    // function activate
    function activate(uint _ticketCost) public OnlyManager override  {
        require(currentStatus == Status.inactive);
        ticketCost = _ticketCost;

        currentStatus = Status.isPrepared;
    }

    // function getTicketCost
    function getTicketCost() public view override returns (uint){
        return ticketCost;
    }

    function buyTicket(string memory _name) public payable override  {
        require(currentStatus == Status.isPrepared || currentStatus == Status.isActive);
        require(msg.value == ticketCost, "Wrong value");
        require(players[msg.sender].wallet == address(0), "You are already playing");

        Player storage player = players[msg.sender];

        playerList.push(msg.sender);

        player.name = _name;
        player.wallet = msg.sender;
        player.index = playerList.length;

        currentStatus = Status.isActive;

        emit NewPlayer(name);
    }

    function getMyInfo() public view returns(string memory, address, uint) {
        Player storage player = players[msg.sender];

        return (player.name, player.wallet, player.index);
    }

    function getPlayerInfo(address playerAddress) 
        external view OnlyManager 
        returns(string memory, address, uint)  {

        Player storage player = players[playerAddress];

        return (player.name, player.wallet, player.index); // ["", 0, 0]
    }

    /*fallback() external payable {

    }*/

    receive() external payable {
        buyTicket("unknown");
    }

    function generateRandomNumber() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(
            block.timestamp, 
            block.difficulty, 
            msg.sender)
        ));
    } 

    function pickWinner() OnlyManager external payable override  {
        uint indexWinner = generateRandomNumber() % playerList.length;

        address payable winnerAddress = playerList[indexWinner];

        winnerAddress.transfer(address(this).balance);

        winner = players[winnerAddress];

        currentStatus = Status.isFinished;

        emit LotteryFinished(winnerAddress);

    }      
}