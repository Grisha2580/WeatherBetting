pragma solidity^0.4.25;

import "./WeatherOracle.sol";

contract Betting {

    struct Bet {
        address addr;
        uint predictedValue;
    }

    uint constant minimumBet = 0.5 ether;

    mapping(uint => Bet[]) private currentBets;

    uint[] daysWithBets;

    address[] mostRecentWinners;

    address oracleAddress;

    constructor (address _oracleAddress) public {
        oracleAddress = _oracleAddress;
    }

    function makeBet(uint unixTime, uint _predictedValue) public payable {
        // This checks that the bet cannot be placed for the current day
        // require(unixTime > now && unixTime - now > 1 days
        // , "The time provided has already passed for betting on");
        require(msg.value == minimumBet, "The ether sent must equal the minimum bet amount");

        // if there are no bets on this day add the day to the list of bets
        if (currentBets[unixTime].length == 0) {
            daysWithBets.push(unixTime);
        }
        // Create the bet and push it to the array for the given day
        Bet memory bet = Bet(msg.sender, _predictedValue);
        currentBets[unixTime].push(bet);

    }

    function getNumBets(uint unixTime) public view returns (uint numBets) {
        return currentBets[unixTime].length;
    }

    // Function is called to see if the date has passed and anyone needs to be payed out
    function payOut() public returns (bool) {
        for (uint i = 0; i < daysWithBets.length; i++) {
            if (daysWithBets[i] < now) {
                distributeMoney(currentBets[daysWithBets[i]]);
                // Remove this day from the list of days with bets since it has passed
                daysWithBets[i] = daysWithBets[daysWithBets.length-1];
                delete daysWithBets[daysWithBets.length-1];
                daysWithBets.length--;
                return true;
            }
        }
        return false;
    }

    // This function checks the oracle to see who won and distributes the money accordingly
    function distributeMoney(Bet[] bets) private {
        WeatherOracle weather_oracle = WeatherOracle(oracleAddress);
        uint temprature = weather_oracle.getTemperature();
        // INVARIANT: The length of the bets list will always be at least 1
        uint closestValue = abs(temprature, bets[0].predictedValue);
        delete mostRecentWinners; // clears the array
        mostRecentWinners.push(bets[0].addr);
        // Compute the list of winners
        for (uint i = 1; i < bets.length; i++) {
            if (abs(temprature, bets[i].predictedValue) == closestValue) {
                mostRecentWinners.push(bets[i].addr);
            }
            else if (abs(temprature, bets[i].predictedValue) < closestValue) {
                closestValue = abs(temprature, bets[i].predictedValue);
                delete mostRecentWinners;
                mostRecentWinners.push(bets[i].addr);
            }
        }
        // Pay out the current winners
        uint winnerPayout = minimumBet * bets.length / mostRecentWinners.length;
        for (uint j = 0; j < mostRecentWinners.length; j++) {
            address winner = mostRecentWinners[j];
            winner.transfer(winnerPayout);
        }
    }


    // Helper function for computing the absolute value between two numbers
    function abs(uint num1, uint num2) private returns (uint absValue) {
        int difference = int(num1) - int(num2);
        if (difference < 0) {
            return uint(-1 * difference);
        }
        else {
            return uint(difference);
        }
    }

}