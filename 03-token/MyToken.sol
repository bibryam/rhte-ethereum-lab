pragma solidity ^0.4.0;

contract MyToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;


    /*     constructor () public {
    balanceOf[msg.sender] = 21000000;
}*/


    constructor(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    }


    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }


}
