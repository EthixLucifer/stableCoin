//SPDX-License-Identifier: MIT License

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ETHX is ERC20, ERC20Burnable, Ownable, AccessControl{
    using SafeMath for uint256;
    using SafeERC20 for ERC20;
    mapping(address => uint256) private _balances;
    
    uint256 private _totalSupply;
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor () Ownable(_msgSender()) ERC20("ETHX Token", "ETHX") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(MANAGER_ROLE, _msgSender());
    }

    function mint(uint256 amount) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "Not allowed to mint any tokens");
        //not mandatory but makes the code clean
        _totalSupply = _totalSupply.add(amount);
        _balances[_msgSender()] = _balances[_msgSender()].add(amount);
        _mint(msg.sender, amount);
    }
 
}