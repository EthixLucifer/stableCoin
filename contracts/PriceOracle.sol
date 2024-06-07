//SPDX-License-Identifier: MIT License

pragma solidity ^0.8.6;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PriceOracle{
    using SafeMath for uint256;
    AggregatorV3Interface private priceOracle;
    uint256 public unstableCollateralPrice;
    address public datafeed;

    function setDataFeedAddress(address contractAddress) external {
        datafeed = contractAddress;
        priceOracle = AggregatorV3Interface(datafeed);
     
    }

    function colPriceToWei () external {
           (, uint256 price, , ,) = priceOracle.latestRoundData();
        unstableCollateralPrice = price.mul(1e10);
    
    }

    function rawcolPrice () external view returns (uint256) {
           (, uint256 price, , ,) = priceOracle.latestRoundData();
        return price;
    
    }
}

//Amoy addr: 0x6126058496218fF1f81FB7c16F2C767E2E2aB06D