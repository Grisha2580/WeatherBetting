// import startOracle from "./oracle";
// import startConsumer from "./consumer";
//
// startOracle();
// startConsumer();
const request = require('request');
var {testing} = require('./ethereum')

var URL = "https://www.metaweather.com/api/location/2367105/"

const start = () => {
  parseData(URL)
  // .then(updateWeather)
  .testing()
  .then(data => console.log(data))
  // .then(console.log(process.env))
  .catch(function genericError(error) {
    console.log(error)
  })
  // .then(updateWeather)
  // .then(restart)
  // .catch(error);
};

const parseData = (url) => {
  return new Promise((resolve, reject) => {
    // let weatherDescription, temperature, humidity, visibility, windSpeed, windDirection, windGust;
    try {
      request(url, { json: true }, (err, res, body) => {
        if (err) { return console.log(err); }
        console.log(body.consolidated_weather[0])
      resolve(body.consolidated_weather[0].the_temp);
    });
      // weatherDescription = body.weather[0].description.toString();
      // temperature = body.main.temp.toString();
      // humidity = body.main.humidity.toString();
      // visibility = body.visibility.toString();
      // windSpeed = body.wind.speed.toString();
      // windDirection = body.wind.deg.toString();
      // windGust = (body.wind.gust || 0).toString();
    } catch(error) {
      reject(error);
      return;
    }
    // resolve({ weatherDescription, temperature, humidity, visibility, windSpeed, windDirection, windGust });
  });
};



start()
