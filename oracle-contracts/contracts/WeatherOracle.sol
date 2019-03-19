pragma solidity ^0.4.25;


contract WeatherOracle {
  address public oracleAddress;

  constructor (address _oracleAddress) public {
    oracleAddress = _oracleAddress;
  }

  event WeatherUpdate (string temperature);

  function updateWeather (string temperature) public {
    require(msg.sender == oracleAddress);

    emit WeatherUpdate (temperature);
  }
}
