const LotteryCreator = artifacts.require("LotteryCreator");

contract("LotteryCreator", accounts => {
    const from = accounts[0];

    it("should obtain getLotteriesQuantity", async () => {
        const creator = await LotteryCreator.deployed();
        const quantity = await creator.getLotteriesQuantity({ from });

        assert.equal(quantity, 0, "Wrong Quantity");
    })

    it("should increment quantity", async () => {
        const creator = await LotteryCreator.deployed();
        await creator.createLottery("SorteoONGBitcoin", { from });
        const quantity = await creator.getLotteriesQuantity({ from });

        assert.equal(quantity, 1, "Wrong Quantity");        
    })

    it("should obtain one lottery data", async () => {
        const creator = await LotteryCreator.deployed();
        const name = "SorteoONGBitcoin";
        await creator.createLottery(name, { from });
        const lotteryData = await creator.getLottery(name, { from });
        assert.equal(lotteryData.name, name, "Wrong name"); 
        assert(lotteryData.timestamp > 0, "Major to zero"); 
    })    
})