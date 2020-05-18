const FlashloanTaker = artifacts.require("FlashloanTaker");

module.exports = function(deployer) {
  deployer.deploy(FlashloanTaker);
};
