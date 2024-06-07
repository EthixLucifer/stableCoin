//SPDX-License-Identifer: MIT

pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract USDT is ERC20, ERC20Burnable {
    using SafeERC20 for ERC20; 
    address owner = msg.sender;
    modifier onlyOwner () {
        require (msg.sender == owner);
        _;
    } 

    constructor() ERC20("Tether USD", "USDT") {
        owner = msg.sender;
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }
}

//Amoy Address: 0x81ac51d7f37Dc921877969CFE40dcbAb09693249