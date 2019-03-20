pragma solidity ^0.4.25;


contract WeatherOracle {
  address public oracleAddress;
  uint temperature;

  constructor (address _oracleAddress) public {
    oracleAddress = _oracleAddress;
  }

  event WeatherUpdate (uint temperature);

  function updateWeather (uint _temperature) public {
    require(msg.sender == oracleAddress);
    temperature = _temperature;
    emit WeatherUpdate (temperature);
  }

  function getTemperature() public view returns (uint temp) {
    return temperature;
  }
}
