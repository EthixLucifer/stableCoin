//SPDX-License-Identifer: MIT

pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract WETH is ERC20, ERC20Burnable {
    using SafeERC20 for ERC20; 
    address owner = msg.sender;
    modifier onlyOwner () {
        require (msg.sender == owner);
        _;
    } 

    constructor() ERC20("Wrapped ETH", "WETH") {
        owner = msg.sender;
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }
}

//Amoy Addr: 0x10bA30Cc5a2986c27A722dB1AfcbFE196302c3D7