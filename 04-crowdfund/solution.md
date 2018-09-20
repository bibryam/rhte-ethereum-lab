## 4. Token Sale

The exercise from this section builds on 03-token section.

## Task 7.1 - Centralized Administrator
```
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
        /* the rest of the contract as usual */
```
## Task 7.2 - Central Mint
```
    function mintToken(address target, uint256 mintedAmount) onlyOwner public {
        balanceOf[target] += mintedAmount;
    }
```

## Task 7.3 - Emit Events
```
    event Transfer(address indexed from, address indexed to, uint256 value);
```

```
    function mintToken(address target, uint256 mintedAmount) onlyOwner public {
        balanceOf[target] += mintedAmount;
        emit Transfer(0x0000000000000000000000000000000000000000, owner, mintedAmount);
        emit Transfer(owner, target, mintedAmount);
    }
```

## Task 7.4 - Selling tokens
```
    uint256 public sellPrice;
    
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
```
