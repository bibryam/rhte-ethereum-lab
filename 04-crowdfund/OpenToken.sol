pragma solidity ^0.4.0;

contract owned {
    address public owner;

    constructor () public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract OpenToken is owned {
    /* This creates a map with all address balances */
    mapping (address => uint256) public balanceOf;

    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 public sellPrice;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits) public {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }

    function transfer(address _to, uint256 _value) public {
        /* Check if sender has balance and for overflows */
        require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner public {
        balanceOf[target] += mintedAmount;
        emit Transfer(0x0000000000000000000000000000000000000000, owner, mintedAmount);
        emit Transfer(owner, target, mintedAmount);
    }

    function setPrices(uint256 newSellPrice) onlyOwner public {
        sellPrice = newSellPrice;
    }


    function sell(uint amount) public returns (uint revenue) {
        require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
        balanceOf[address(this)] += amount;                        // adds the amount to owner's balance
        balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
        revenue = amount * sellPrice;
        msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
        return revenue;                                   // ends function and returns
    }
}
