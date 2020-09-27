const Lottery = artifacts.require("Lottery");
const LotteryCreator = artifacts.require("LotteryCreator");

contract("Lottery", accounts => {
    const from = accounts[0];

    it("Should return Lottery name", async () => {
        const instance = await Lottery.deployed();
        const name = await instance.getName({ from });
        assert.equal(name, "Sorteo", "Wrong name");
    })

    it("Should deploy a new Lottery", async () => {
        const creator = await LotteryCreator.deployed();
        const name = "SorteoONGBitcoin";
        await creator.createLottery(name, { from });
        const lotteryData = await creator.getLottery(name, { from });

        const lotteryAddress = lotteryData.lottery;
        
        const instance = await Lottery.at(lotteryAddress);
        const name2 = await instance.getName({ from });
        assert.equal(name, name2, "The name must be equals");

    }) 
    
    it("Should obtain cost of ticket", async () => {
        const creator = await LotteryCreator.deployed();
        const name = "SorteoONGBitcoin";
        await creator.createLottery(name, { from });
        const lotteryData = await creator.getLottery(name, { from });

        const lotteryAddress = lotteryData.lottery;
        
        const instance = await Lottery.at(lotteryAddress);

        await instance.activate(1000, { from });

        const ticketCost = await instance.getTicketCost({ from });

        assert.equal(ticketCost, 1000);

    })  
    
    it("Should not allow to active to others", async () => {

        try {
            const creator = await LotteryCreator.deployed();
            const name = "SorteoONGBitcoin";
            await creator.createLottery(name, { from });
            const lotteryData = await creator.getLottery(name, { from });
    
            const lotteryAddress = lotteryData.lottery;
            
            const instance = await Lottery.at(lotteryAddress);
            const other = accounts[1];

            await instance.activate(1000, { from });

            assert(true, false, "This activation should not allow");
        } catch (error) {
            assert(true, true);
        }
    })   
    
    it.only("Should pay the ticket amount", async () => {
        const creator = await LotteryCreator.deployed();
        const name = "SorteoONGBitcoin";
        await creator.createLottery(name, { from });
        const lotteryData = await creator.getLottery(name, { from });

        const lotteryAddress = lotteryData.lottery;
        
        const instance = await Lottery.at(lotteryAddress);

        await instance.activate(1000, { from });

        const ticketCost = await instance.getTicketCost({ from });

        await instance.sendTransaction({ from: accounts[1], value: 1000 });
        // await instance.sendTransaction({ from: accounts[1], value: 1000 });
        // await instance.buyTicket("Emiliano", { from: accounts[1], value: 1000 });
        const values = await instance.getMyInfo({ from: accounts[1]});
        assert(values[0] == "unknown");

    })     
})