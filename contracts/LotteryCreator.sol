// SPDX-License-Identifier: MIT 
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import { Lottery } from "./Lottery.sol";
import { ILottery } from './ILottery.sol';

contract LotteryCreator {
    struct LotteryData {
        string name;
        address manager;
        uint timestamp;
        ILottery lottery;
    }

    mapping (string => LotteryData) lotteries;

    uint quantity = 0;

    function getLotteriesQuantity() public view returns(uint) {
        return quantity;
    }

    function createLottery(string memory name) public {
        LotteryData storage data = lotteries[name];

        data.name = name;
        data.manager = msg.sender;
        data.timestamp = block.timestamp;
        data.lottery = new Lottery(name, msg.sender);

        quantity++;
    }   

    function addLottery(ILottery lottery) public {
        LotteryData storage data = lotteries[lottery.getName()];

        data.name = lottery.getName();
        data.manager = msg.sender;
        data.timestamp = block.timestamp;
        data.lottery = lottery;

        quantity++;
    } 

    function getLottery(string memory name) public view returns(LotteryData memory) {
        return lotteries[name];
    }

}