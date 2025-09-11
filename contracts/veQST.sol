// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract WrappedQST is ERC20, ERC20Burnable, ERC20Wrapper, ReentrancyGuard {
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    //solhint-disable-next-line no-empty-blocks
    constructor(IERC20 wrappedQST)
	    ERC20("Wrapped QST", "veQST")
		ERC20Wrapper(wrappedQST)
	{}

    function deposit() external payable nonReentrant {
        _deposit();
    }

    function withdraw(uint256 amount) external nonReentrant {
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    receive() external payable nonReentrant {
        _deposit();
    }

    function _deposit() internal {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }
}
