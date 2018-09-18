pragma solidity ^0.4.0;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}


contract OpenToken is owned {
    /* This creates a map with all address balances */
    mapping (address => uint256) public balanceOf;


    function transfer(address _to, uint256 _value) public {
        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
}
