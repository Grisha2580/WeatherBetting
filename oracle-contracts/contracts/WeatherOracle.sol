pragma solidity ^0.4.25;


contract WeatherOracle {
  address public oracleAddress;
  string temperature;

  constructor (address _oracleAddress) public {
    oracleAddress = _oracleAddress;
  }

  event WeatherUpdate (string temperature);

  function updateWeather (string _temperature) public {
    require(msg.sender == oracleAddress);
    temperature = _temperature;
    emit WeatherUpdate (temperature);
  }

  function getTemperature() public returns (string temperature) {
    return temperature;
  }
}
