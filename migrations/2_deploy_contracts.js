var WeatherOracle = artifacts.require("../contracts/WeatherOracle.sol");

module.exports = function(deployer, network) {
  deployer.deploy(WeatherOracle, "0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1");
};
