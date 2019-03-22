
// Import libraries we need.
import { default as Web3 } from 'web3';
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them into usable abstractions.
import BettingArtifact from '../build/contracts/Betting.json';

// Create the Betting contract
const BettingContract = contract(BettingArtifact);

console.log("Work work");

window.addEventListener('load', function() {
  // Checks if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 != 'undefined') {
    web3 = new Web3(web3.currentProvider);
    console.log("Using web3 detected from external source like Metamask");
    console.log(web3);
  } else {
    alert("Please download MetaMask to use this app");
  }
  web3.eth.defaultAccount = web3.eth.accounts[0];
  // startApp();
});
