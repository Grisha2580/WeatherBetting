pragma solidity^0.4.25;

import "./Ownable.sol";
import "./DateLib.sol";

contract Betting {

    using DateLib for DateLib.DateTime;

    struct Bet {
        address addr;
        uint predicted_value;
    }

    uint constant minimumBet = 0.5 ether;

    mapping(uint => Bet[]) currentBets;

    function makeBet(uint16 _year, uint8 _month, uint8 _day, uint _predicted_value) public {
        // This checks that the bet cannot be placed for the current day
        // require(DateLib.DateTime(_year, _month, _day, 0, 0, 0, 0, 0).toUnixTimestamp()) - now > 1 days);
        Bet memory bet = Bet(msg.sender, _predicted_value);
        currentBets[DateLib.DateTime(_year, _month, _day, 0, 0, 0, 0, 0).toUnixTimestamp()].push(bet);


    }
}