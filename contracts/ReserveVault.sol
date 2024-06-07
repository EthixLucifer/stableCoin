//SPDX-License-Identifier: MIT LICENSE

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

pragma solidity ^0.8.6;

contract ETHIXUSDRESERVE is ReentrancyGuard, AccessControl {
    // address owner;
    // modifier onlyOwner {
    //     require(msg.sender == owner);
    //     _;
    // }

    

    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    uint256 public currentReserveTokenId; 

    struct reserveVault {
        IERC20 collateral;
        uint256 amount;
    }

    mapping(uint256 => reserveVault) public _rsvVault;

    event Withdraw (uint256 indexed vaultId, uint256 amount);
    event Deposit (uint256 indexed vaultId, uint256 amount);

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor () {
        // // owner = msg.sender;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MANAGER_ROLE, msg.sender);
    }

    function checkReserveContract(IERC20 _collateral) internal view {
        for(uint256 i; i< currentReserveTokenId; i++) {
        require(_rsvVault[i].collateral != _collateral, "Collateral Address Already Exists at Vault ");


        }
    }

    function addReserveVault (IERC20 _collateral) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not Allowed to Add a Reserve Vault");
        checkReserveContract(_collateral);
        _rsvVault[currentReserveTokenId].collateral = _collateral;
        currentReserveTokenId++;
    }

    function depositCollateral (uint256 id, uint256 amount) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not Allowed to Deposit the Collateral");
        IERC20 reserves = _rsvVault[id].collateral;
        reserves.safeTransferFrom(address(msg.sender), address(this), amount);
        uint256 currentVaultAmount = _rsvVault[id].amount;
        _rsvVault[id].amount = currentVaultAmount.add(amount);
        emit Deposit(id, amount);
    }

    function withdrawCollateral (uint256 id, uint256 amount) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not Allowed to Withdraw");
        IERC20 reserves = _rsvVault[id].collateral;
        uint256 curreVaultAmount = _rsvVault[id].amount;
        if (curreVaultAmount >= amount) {
            reserves.safeTransfer(address(msg.sender), amount);
            _rsvVault[id].amount = curreVaultAmount.sub(amount);
            emit Withdraw(id, amount);
        }
    }
}

//Amoy Address: 0xEEe3CA8A01e5cb4dF257059113F7e54e9BAbb83d