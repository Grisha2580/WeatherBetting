pragma solidity^0.4.25;

import "./Ownable.sol";
import "./DateLib.sol";
import "./WeatherOracle.sol";

contract Betting {

    using DateLib for DateLib.DateTime;

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

    function makeBet(uint16 _year, uint8 _month, uint8 _day, uint _predictedValue) public payable {
        // This checks that the bet cannot be placed for the current day
        // require(DateLib.DateTime(_year, _month, _day, 0, 0, 0, 0, 0).toUnixTimestamp()) - now > 1 days);
        require(msg.value == minimumBet);

        // if there are no bets on this day add the day to the list of bets
        if (currentBets[DateLib.DateTime(_year, _month, _day, 0, 0, 0, 0, 0).toUnixTimestamp()].length == 0) {
            daysWithBets.push(DateLib.DateTime(_year, _month, _day, 0, 0, 0, 0, 0).toUnixTimestamp());
        }
        // Create the bet and push it to the array for the given day
        Bet memory bet = Bet(msg.sender, _predictedValue);
        currentBets[DateLib.DateTime(_year, _month, _day, 0, 0, 0, 0, 0).toUnixTimestamp()].push(bet);

    }

    function getNumBets(uint16 _year, uint8 _month, uint8 _day) public view returns (uint numBets) {
        return currentBets[DateLib.DateTime(_year, _month, _day, 0, 0, 0, 0, 0).toUnixTimestamp()].length;
    }

    // Function is called to see if the date has passed and anyone needs to be payed out
    function payOut() public {
        for (uint i = 0; i < daysWithBets.length; i++) {
            if (daysWithBets[i] < now) {
                distributeMoney(currentBets[daysWithBets[i]]);
                // Remove this day from the list of days with bets since it has passed
                daysWithBets[i] = daysWithBets[daysWithBets.length-1];
                delete daysWithBets[daysWithBets.length-1];
                daysWithBets.length--;
                break;
            }
        }
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
            mostRecentWinners[i].transfer(winnerPayout);
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