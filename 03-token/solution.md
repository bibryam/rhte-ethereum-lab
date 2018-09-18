# Minimum Viable Token

## 1.Simple storage contract
```
pragma solidity ^0.4.0;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
```

## 2. OpenToken contract
```
contract OpenToken {
    /* This creates a map with all address balances */
    mapping (address => uint256) public balanceOf;
}
```

## 3. OpenToken constructor
```
    constructor(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    }
```

## 4. Transfer

```
/* Send coins */
function transfer(address _to, uint256 _value) public {
    /* Add and subtract new balances */
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
}
```

## 5. Validate
```
function transfer(address _to, uint256 _value) public {
    /* Check if sender has balance and for overflows */
    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

    /* Add and subtract new balances */
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
}
```

## 6. Description
```
/* Initializes contract with initial supply tokens to the creator of the contract */
function OpenToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
    balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
    name = tokenName;                                   // Set the name for display purposes
    symbol = tokenSymbol;                               // Set the symbol for display purposes
    decimals = decimalUnits;                            // Amount of decimals for display purposes
}

```
