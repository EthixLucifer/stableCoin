// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./ETHX.sol";

contract ETHXGovernance is Ownable, ReentrancyGuard, AccessControl {

using SafeMath for uint256;
using SafeERC20 for ERC20;

struct SupChange {
    string method; 
    uint256 amount;
    uint256 timeStamp;
    uint256 blockNo;
    
}

struct ReserveList {
    IERC20 collateralToken;
}

mapping (uint256 => ReserveList) public rsvList;



ETHX private ethx;
AggregatorV3Interface private priceOracle;
address private stableCoin;
uint256 public ethxSupply;
//chainlnkk contract to fetch prices in real-time
address public datafeed;
uint256 public supplyChangeCount;
uint256 public stableCollateralPrice = 1e18;
uint256 public stableCollateralAmount;
uint256 private constant COL_PRICE_TO_WEI = 1e10;
uint256 private constant WEI_VALUE = 1e18;
//Dynamically Adjusted 
uint256 public unstableCollateralAmount;
//Fetched from the chainlink Datafeed
uint256 public unstableCollateralPrice;
uint256 public reserveCount;
mapping (uint256 => SupChange) public _supplyChange;

bytes32 public constant GOVERN_ROLE = keccak256("GOVER_ROLE");

event RepegAction(uint256 time, uint256 amount ); //string method
event Withdraw(uint256 time, uint256 amount);


constructor(ETHX _ethx) Ownable(msg.sender){

ethx = _ethx;
_grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
_grantRole(GOVERN_ROLE, _msgSender());

}

function addCollateralToken(IERC20 collateralContract) external nonReentrant {
    require(hasRole(GOVERN_ROLE, _msgSender()), "You are not allowed to add the Collateral Token");
    rsvList[reserveCount].collateralToken = collateralContract;
    reserveCount++;

 
}

//Updating the Chainlink Oracle Data Feed Contract Address
function setDataFeedAddress(address contractAddress) external {
require(hasRole(GOVERN_ROLE, _msgSender()), "You are not allowed to add the Collateral Token");
datafeed = contractAddress;
}
}