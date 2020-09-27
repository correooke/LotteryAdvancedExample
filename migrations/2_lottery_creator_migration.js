const LotteryCreator = artifacts.require("LotteryCreator");

module.exports = function (deployer) {
  deployer.deploy(LotteryCreator);
};
