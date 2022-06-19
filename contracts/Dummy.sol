//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

//import "hardhat/console.sol";

contract Dummy{
    mapping (uint256 => uint256) q;
    fallback() external {
        //console.log("FALLBACK CALLED");
        q[1] = 1;
    }
    function getQ(uint256 n) public view returns(uint256){
        //console.log("GETQ CALLED");
        return q[n];
    }

    function setQ(uint256 k,uint256 v) public{
        //console.log("SETQ CALLED");
        q[k] = v;
    }
    function getCode(address addr) public view returns(uint256,uint256,uint256,uint256){
        uint256[3] memory code;
        uint256 s;
        assembly{
            let cS := extcodesize(addr)
            s := cS
            extcodecopy(addr,code,0,cS)
        }
        return (s,code[0],code[1],code[2]);
    }
}