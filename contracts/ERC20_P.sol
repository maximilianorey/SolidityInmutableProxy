//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import '@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';

contract ERC20_P is ERC20Upgradeable{
    function init() initializer external {
        __ERC20_init("HELLO","H");
    }
    function init2(string memory name, string memory symbol) initializer external {
        __ERC20_init(name,symbol);
    }
    function mint(address account, uint256 amount) public{
        _mint(account, amount);
    }
}