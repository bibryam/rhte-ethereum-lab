## 4. Token Sale

The exercise from this section builds on 03-token section.

#### 4.1 Centralized Administrator

```
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
```


    contract OpenToken is owned {
        /* the rest of the contract as usual */

#### 4.1 Central Mint


```
    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        emit Transfer(0, owner, mintedAmount);
        emit Transfer(owner, target, mintedAmount);
    }
```

#### 4.2 Emit Events

    event Transfer(address indexed from, address indexed to, uint256 value);



```
    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        emit Transfer(0, owner, mintedAmount);
        emit Transfer(owner, target, mintedAmount);
    }
```

#### 4.3 Selling and buying
```
    uint256 public sellPrice;
    uint256 public buyPrice;

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }
    
    
     function buy() payable returns (uint amount){
            amount = msg.value / buyPrice;                    // calculates the amount
            _transfer(this, msg.sender, amount);
            return amount;
        }
    
        function sell(uint amount) returns (uint revenue){
            require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
            balanceOf[this] += amount;                        // adds the amount to owner's balance
            balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
            revenue = amount * sellPrice;
            msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
            Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
            return revenue;                                   // ends function and returns
        }
    
```
