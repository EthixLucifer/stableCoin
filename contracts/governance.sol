// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.18.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./ethixusd.sol";
import "./ethix.sol";

contract Governance is Ownable, ReentrancyGuard, AccessControl { 
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct SupChange {
        string method;
        uint256 amount;
        uint256 timestamp;
        uint256 blocknum;
    }

    struct ReserveList {
        IERC20 colToken;
    }

    mapping (uint256 => ReserveList) public rsvList;

    ETHIXUSD private ethixusd;
    ETHIX private ethix;
    address private reserveContract;
    uint256 public ethixUSDsupply;
    uint256 public ethixsupply;
    address public datafeed;
    uint256 public supplyChangeCount;
    uint256 public stableColatPrice = 1e18; 
    uint256 public stableColatAmount;
    uint256 private constant COL_PRICE_TO_WEI = 1e10;
    uint256 private constant WEI_VALUE = 1e18;
    uint256 public unstableColatAmount;
    uint256 public unstableColPrice;
    uint256 public reserveCount;

    mapping (uint256 => SupChange) public _supplyChanges;

    bytes32 public constant GOVERN_ROLE = keccak256("GOVERN_ROLE");

    event RepegAction(uint256 time, uint256 amount);
    event Withdraw(uint256 time, uint256 amount);

    constructor(ETHIXUSD _ethixusd, ETHIX ethix) Ownable(msg.sender){
        ethixusd = _ethixusd;
        ethix = ethix;
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(GOVERN_ROLE, _msgSender());
    }

    function addColateralToken(IERC20 colcontract) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        rsvList[reserveCount].colToken = colcontract;
        reserveCount++;
    }

    function setReserveContract(address reserve) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        reserveContract = reserve;
    }

    function ethix2drTokenPrice(uint256 marketcap) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        ethixsupply = ethix.totalSupply();
        unstableColPrice = ((marketcap).mul(ethixsupply)).div(WEI_VALUE);
    }


    function colateralReBalancing() internal returns (bool) {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        uint256 stableBalance = rsvList[0].colToken.balanceOf(reserveContract);
        uint256 unstableBalance = rsvList[1].colToken.balanceOf(reserveContract);
        if (stableBalance != stableColatAmount) {
            stableColatAmount = stableBalance;
        }
        if (unstableBalance != stableColatAmount) {
            unstableColatAmount = unstableBalance;
        }
        return true;
    }

    function setETHIXUSDSupply(uint256 totalSupply) external {
         require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
         ethixUSDsupply = totalSupply;
    }

    function validatePeg() external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        bool result = colateralReBalancing();
        if (result == true) {
            uint256 rawcolvalue = (stableColatAmount.mul(WEI_VALUE)).add(unstableColatAmount.mul(unstableColPrice));
            uint256 colvalue = rawcolvalue.div(WEI_VALUE);
            if (colvalue < ethixUSDsupply) {
                uint256 supplyChange = ethixUSDsupply.sub(colvalue);
                uint256 burnAmount = (supplyChange.div(unstableColPrice)).mul(WEI_VALUE);
                ethix.burn(burnAmount);
                _supplyChanges[supplyChangeCount].method = "Burn";
                _supplyChanges[supplyChangeCount].amount = supplyChange;
            }
            if (colvalue > ethixUSDsupply) {
                uint256 supplyChange = colvalue.sub(ethixUSDsupply);
                ethixusd.mint(supplyChange);
                _supplyChanges[supplyChangeCount].method = "Mint";
                _supplyChanges[supplyChangeCount].amount = supplyChange;
            }
        _supplyChanges[supplyChangeCount].blocknum = block.number;
        _supplyChanges[supplyChangeCount].timestamp = block.timestamp;
        supplyChangeCount++;
        emit RepegAction(block.timestamp, colvalue);
        }
    }

    function withdraw(uint256 _amount) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        ethixusd.transfer(address(msg.sender), _amount);
        emit Withdraw(block.timestamp, _amount);
    }

    function withdrawEthix(uint256 _amount) external nonReentrant {
        require(hasRole(GOVERN_ROLE, _msgSender()), "Not allowed");
        ethix.transfer(address(msg.sender), _amount);
        emit Withdraw(block.timestamp, _amount);
    }


}

