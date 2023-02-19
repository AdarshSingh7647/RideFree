// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "../node_modules/@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error RideFree__PayEqualOrMoreThanFare();//Completed
error RideFree__TransferFailedFromRider();//Completed
error RideFree__TransferFailedToDriver();//Completed
error RideFree__RideCancelledByRider();//
error RideFree__RideCancelledByDriver();

contract rideFree {
    // Events
    event RiderCancelled();
    event DriverCancelled();
    event RideSuccessful();

    // State variables
    AggregatorV3Interface internal priceFeed;
    address public rider;
    int private immutable fareUSD;
    
    //Constructor
    constructor(address riderAddress,int amount) {
        rider = riderAddress;
        fareUSD = amount;
        priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
    }

    function transferFareFromRider() public payable {
        uint feeETH = getLatestETH_USD() * uint(fareUSD);
        if(feeETH > msg.value)
        revert RideFree__PayEqualOrMoreThanFare();

        bool result = payable(msg.sender).send(uint256(feeETH));

        if(!result)
        revert RideFree__TransferFailedFromRider();

        
    }
    // Make private when deploed to avoid theft.
    function releaseFareToDriver(address payable driverAddress) public {
        uint256 releaseAmount = address(this).balance;
        bool success = driverAddress.send(releaseAmount);
        if(!success)
        revert RideFree__TransferFailedToDriver();
        emit RideSuccessful();
    }
    
    function riderCancel() public {
        emit RiderCancelled();
        revert RideFree__RideCancelledByRider();
    }
    function driverCancel() public {
        emit DriverCancelled();
        revert RideFree__RideCancelledByDriver();
    }
    // Getter Functions
    function getLatestETH_USD() public view returns (uint) {
        ( ,int price,,, ) = priceFeed.latestRoundData();
        uint8 numberOfDecimal = priceFeed.decimals();
        uint latestPrice = uint(price) / uint(10**numberOfDecimal);
        return latestPrice;
    }

    function getContractBalance() public view returns (uint256){
        return (address(this).balance);
    }
}