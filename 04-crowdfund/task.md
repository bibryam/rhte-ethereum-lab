# Token Sale

The exercise from this section builds on 03-token section.

## 1. Centralized Administrator
 All dapps are fully decentralized by default, but that doesn't mean they can't have some sort of central manager, if you want them to. Maybe you want the ability to mint more coins, maybe you want to ban some people from using your currency. You can add any of those features, but the catch is that you can only add them at the beginning, so all the token holders will always know exactly the rules of the game before they decide to own one.
 
 For that to happen, you need a central controller of currency. This could be a simple account, but could also be a contract and therefore the decision on creating more tokens will depend on the contract: if it's a democratic organization that can be up to vote, or maybe it can be just a way to limit the power of the token owner.
 
 In order to do that we'll learn a very useful property of contracts: inheritance. Inheritance allows a contract to acquire properties of a parent contract, without having to redefine all of them. This makes the code cleaner and easier to reuse. Add this code to the first line of your code, before contract MyToken {.

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

This creates a very basic contract that doesn't do anything except define some generic functions about a contract that can be "owned". Now the next step is just to add the text is owned to your contract:


Make OpenToken owned

#### 4.1 Central Mint

Suppose you want the amount of coins in circulation to change. This is the case when your tokens actually represent an off blockchain asset (like gold certificates or government currencies) and you want the virtual inventory to reflect the real one. This might also be the case when the currency holders expect some control of the price of the token, and want to issue or remove tokens from circulation.


Now let's add a new function finally that will enable the owner to create new tokens:

    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        emit Transfer(0, owner, mintedAmount);
        emit Transfer(owner, target, mintedAmount);
    }



#### 4.2 Emit Events
Create an Transfer event with the following fields:

    event Transfer(address indexed from, address indexed to, uint256 value);


Broadcast these events so other tools can pick it up
        emit Transfer(0, owner, mintedAmount);
        emit Transfer(owner, target, mintedAmount);

#### 4.3 Selling and buying
So far, you've relied on utility and trust to value your token. But if you want you can make the token's value be backed by Ether (or other tokens) by creating a fund that automatically sells and buys them at market value.


First, let's set the price for buying and selling:

    uint256 public sellPrice;
    uint256 public buyPrice;


Create a function setPrices that can be called only from the owner. The function should allow setting of sellPrice and buyPrice.


    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }
    

This is acceptable for a price that doesn't change very often, as every new price change will require you to execute a transaction and spend a bit of Ether. If you want to have a constant floating price we recommend investigating standard data feeds

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
Notice that this will not create new tokens but change the balance the contract owns. The contract can hold both its own tokens and Ether and the owner of the contract, while it can set prices or in some cases create new tokens (if applicable) it cannot touch the bank's tokens or Ether. The only way this contract can move funds is by selling and buying them.

Note Buy and sell "prices" are not set in Ether, but in wei the minimum currency of the system (equivalent to the cent in the Euro and Dollar, or the Satoshi in Bitcoin). One Ether is 1000000000000000000 wei. So when setting prices for your token in Ether, add 18 zeros at the end.

When creating the contract, send enough Ether to it so that it can buy back all the tokens on the market otherwise your contract will be insolvent and your users won't be able to sell their tokens.

The previous examples, of course, describe a contract with a single central buyer and seller, a much more interesting contract would allow a market where anyone can bid different prices, or maybe it would load the prices directly from an external source.