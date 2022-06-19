//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
CODE OF PROXY:
    CALLDATASIZE
    PUSH1 0x0
    DUP1
    CALLDATACOPY
    PUSH1 0x0
    CALLDATASIZE
    CALLDATASIZE
    PUSH1 0x0
    PUSH20 ---- The value of this push will be overwritten by the address
    GAS
    DELEGATECALL
    RETURNDATASIZE
    PUSH1 0x0
    CALLDATASIZE
    RETURNDATACOPY
    PUSH1 0x2d
    JUMPI
    RETURNDATASIZE
    CALLDATASIZE
    REVERT
    JUMPDEST
    RETURNDATASIZE
    CALLDATASIZE
    RETURN
    
CODE OF PROXY BINARY:
    0x36 // call data size
    0x60
    0x00 // push 0
    0x80 // DUP1 (0)
    0x37 // calldatacopy
    0x60
    0x00 // push 0
    0x36 // call data size (ret offset)
    0x36 // call data size (args length)
    0x60
    0x00
    0x73 // push20. The following zeros will be overwritten by the address
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x00
    0x5A // gas
    0xF4 // delegate call
    0x3D //returnDataSize
    0x60
    0x00
    0x80 // DUP1 (0) (ret offset)
    0x3E //return data copy
    0x60
    0x2E // push DEST OF JUMPI
    0x57 //jumpi
    0x3D //returnDataSize
    0x60
    0x00 // PUSH 0 (ret offset)
    0xFD //revert
    0x5B //jumpdest
    0x3D //returnDataSize
    0x60 
    0x00 // PUSH 0 (ret offset)
    0xF3 //return

"create" assembly instruction expect to recieve a code that returns another code. This second code will be new contract's code.
The code passed to "create" instruction will be
    PUSH 0x32 (CODE LENGTH)
    PUSH 0x00
    DUP2 (CODE LENGTH)
    PUSH 0x0A (FIRST CODE LENGTH)
    DUP3 (0)
    CODECOPY
    RETURN
And then the code of the proxy.
The first code in binary is:
    0x60
    0x34 //PUSH 53
    0x60
    0x00 // PUSH 0
    0x81 // DUP2 (51)
    0x60
    0x0A // PUSH 10
    0x82 // DUP3 (0)
    0x39 // CODECOPY
    0xF3 // RETURN
*/

contract ProxyDeployer {
    event ProxyDeployed(address indexed addrProxy,address indexed addrImpl);
    
    function deployProxy(address addr) public returns (address) {
        uint256[3] memory code;
        address res;
        assembly {
            mstore(code,0x6034600081600A8239F336600080376000363660007300000000000000000000)
            mstore(add(code,22),shl(96,addr))
            mstore(add(code,42),0x5AF43D6000803E602E573D6000FD5B3D6000F300000000000000000000000000)
            res := create(0, code,0x3E)
        }
        emit ProxyDeployed(res, addr);
        return res;
    }
}