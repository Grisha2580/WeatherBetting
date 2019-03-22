pragma solidity ^0.4.25;

import "./Ownable.sol";

contract WeatherOracle is Ownable {
  address public oracleAddress;
  uint temperature;

  event WeatherUpdate (uint temperature);

  function updateWeather (uint _temperature) public onlyOwner {
    require(msg.sender == oracleAddress);
    temperature = _temperature;
    emit WeatherUpdate (temperature);
  }

  function getTemperature() public view returns (uint temp) {
    return temperature;
  }
}
