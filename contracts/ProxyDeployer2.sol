//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
CODE OF PROXY:
    PUSH20 ---- The value of this push will be overwritten by the address
    CALLDATASIZE
    PUSH1 0x0
    PUSH1 0x0
    CALLDATACOPY
    PUSH1 0x0
    CALLDATASIZE
    CALLDATASIZE
    PUSH1 0x0
    DUP5 //AddressZ
    GAS
    DELEGATECALL
    RETURNDATASIZE
    PUSH1 0x0
    CALLDATASIZE
    RETURNDATACOPY
    PUSH1 0x2f
    JUMPI
    RETURNDATASIZE
    CALLDATASIZE
    REVERT
    JUMPDEST
    RETURNDATASIZE
    CALLDATASIZE
    RETURN

CODE OF PROXY BINARY:
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
    0x36 // call data size
    0x60
    0x00 // push 0
    0x60
    0x00 // push 0
    0x37 // calldatacopy
    0x60
    0x00 // push 0
    0x36 // call data size (ret offset)
    0x36 // call data size (args length)
    0x60
    0x00
    0x84 // DUP5 (Address)
    0x5A // gas
    0xF4 // delegate call
    0x3D //returnDataSize
    0x60
    0x00
    0x80 // DUP1 (ret offset)
    0x3E //return data copy
    0x60
    0x30 // push DEST JUMPI
    0x57 //jumpi
    0x3D //returnDataSize
    0x60 // 
    0x00 // PUSH 0 (ret offset)
    0xFD //revert
    0x5B //jumpdest
    0x3D //returnDataSize
    0x60 
    0x00 // PUSH 0 (ret offset)
    0xF3 //return

"create" assembly instruction expect to recieve a code that returns another code. This second code will be new contract's code.
The code passed to "create" instruction will be
    PUSH 0x33 (CODE LENGTH)
    PUSH 0x00
    DUP2 (CODE LENGTH)
    PUSH 0x0b (FIRST CODE LENGTH)
    PUSH 0x00
    CODECOPY
    RETURN
And then the code of the proxy.
The first code in binary is:
    0x60
    0x35 //PUSH 53
    0x60
    0x00 // PUSH 0
    0x81 // DUP2 (52)
    0x60
    0x0B // PUSH 11
    0x60
    0x00 // PUSH 0
    0x39 // CODECOPY
    0xF3 // RETURN
*/

contract ProxyDeployer2 {
    event ProxyDeployed(address indexed addrProxy,address indexed addrImpl);
    
    function deployProxy(address addr) public returns (address) {
        uint256[2] memory code;
        address res;
        assembly {
            mstore(code,or(0x6035600081600B600039F3730000000000000000000000000000000000000000,addr))
            mstore(add(code,32),0x366000600037600036366000845AF43D6000803E6030573D6000FD5B3D6000F3)
            res := create(0, code,0x40)
        }
        emit ProxyDeployed(res, addr);
        return res;
    }
}