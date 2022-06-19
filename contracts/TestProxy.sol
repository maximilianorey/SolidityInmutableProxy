//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import './ERC20_P.sol';
import './ProxyDeployer.sol';
import './ProxyDeployer2.sol';

contract TestProxy{
    function test_P2() external{
        ERC20_P erc20 = new ERC20_P();
        ProxyDeployer pDeployer = new ProxyDeployer();
        address proxy = pDeployer.deployProxy(address(erc20));

        ERC20_P(proxy).init();
        ERC20_P(proxy).mint(address(this),3000);
        ERC20_P(proxy).transfer(address(1),1000);

        require(ERC20_P(proxy).balanceOf(address(this))==2000,'ERROR GET BALANCE');
        require(ERC20_P(proxy).balanceOf(address(1))==1000,'ERROR GET BALANCE');
    }

    function test_P3() external{
        ERC20_P erc20 = new ERC20_P();
        ProxyDeployer2 pDeployer = new ProxyDeployer2();
        address proxy = pDeployer.deployProxy(address(erc20));

        ERC20_P(proxy).init();
        ERC20_P(proxy).mint(address(this),3000);
        ERC20_P(proxy).transfer(address(1),1000);

        require(ERC20_P(proxy).balanceOf(address(this))==2000,'ERROR GET BALANCE');
        require(ERC20_P(proxy).balanceOf(address(1))==1000,'ERROR GET BALANCE');
    }
}