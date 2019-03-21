// require("dotenv").config();

require('web3')
//import HDWalletProvider from "truffle-hdwallet-provider";
//import Web3 from "web3";


const web3 = new Web3.providers.HttpProvider('"http://localhost:8545')
const abi = JSON.parse(process.env.ABI);
const address = process.env.CONTRACT_ADDRESS;
const contract = web3.eth.contract(abi).at(address);

const testing = () => {
  console.log('This is something we need to test')
}

const account = () => {
  return new Promise((resolve, reject) => {
    web3.eth.getAccounts((err, accounts) => {
      if (err === null) {
        resolve(accounts[0]);
      } else {
        reject(err);
      }
    });
  });
};

const updateWeather = (temperature) => {
  return new Promise((resolve, reject) => {
    account().then(account => {
      contract.updateWeather(temperature,
        { from: account }, (err, res) => {
          if (err === null) {
            resolve(res);
          } else {
            reject(err);
          }
        }
      );
    }).catch(error => reject(error));
  });
};

const weatherUpdate = (callback) => {
  contract.WeatherUpdate((error, result) => callback(error, result));
};
