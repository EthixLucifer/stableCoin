// SPDX-License-Identifier: MIT LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract USDT is ERC20, ERC20Burnable, Ownable { 
    //mockup test token to represent collateral of tether usd, 20% collateral 
    // 200000000000000000000000
    // 200K token to be minted initially

  using SafeERC20 for ERC20;

  constructor() Ownable(msg.sender) ERC20("Tether USD", "USDT") {}

  function mint(uint256 amount) external onlyOwner {
    _mint(msg.sender, amount);
  }

}
