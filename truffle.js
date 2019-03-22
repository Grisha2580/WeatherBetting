require('dotenv').config();

const HDWalletProvider = require('truffle-hdwallet-provider');

var infura_apikey = "bdcddc7cc58a4cce8ccac9fa2df51158";
var mnemonic = "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat";


module.exports = {
  networks: {
    development: {
      network_id: '*',
      host: 'localhost',
      port: 8545
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+infura_apikey),
      network_id: 3,
    }
  }
};
