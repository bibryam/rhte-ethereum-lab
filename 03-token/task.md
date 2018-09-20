# Minimum Viable Token

## Task 6.1 - Simple storage contract
Let us begin with the most basic example in Solidity. It is fine if you do not understand everything right now, we will go into more detail later.
Following the above steps, create a new contract `SimpleStorage.sol` with the following content: 

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

 The first line simply tells that the source code is written for Solidity version 0.4.0 or anything newer that does not break functionality (up to, but not including, version 0.5.0). This is to ensure that the contract does not suddenly behave differently with a new compiler version. The keyword pragma is called that way because, in general, pragmas are instructions for the compiler about how to treat the source code (e.g. pragma once).
 
 A contract in the sense of Solidity is a collection of code (its functions) and data (its state) that resides at a specific address on the Ethereum blockchain. The line uint storedData; declares a state variable called storedData of type uint (unsigned integer of 256 bits). You can think of it as a single slot in a database that can be queried and altered by calling functions of the code that manages the database. In the case of Ethereum, this is always the owning contract. And in this case, the functions set and get can be used to modify or retrieve the value of the variable.
 
 To access a state variable, you do not need the prefix this. as is common in other languages.
 
 This contract does not do much yet apart from allowing anyone to store a single number that is accessible by anyone in the world without a (feasible) way to prevent you from publishing this number. Of course, anyone could just call set again with a different value and overwrite your number, but the number will still be stored in the history of the blockchain. Later, we will see how you can impose access restrictions so that only you can alter the number.


From top right corner - Compile:
 - press "Start to compile" button. If required, select a compiler version.
 
From top right corner - Run:
 - Select Environment - JavaScript VM
 - Press Deploy
 - From Deployed Contracts, invoke function "`f`"
 
 
#### References
[Remix Documentation](https://remix.readthedocs.io/en/latest/tutorial_debug.html)  
[Solidity Documentation](https://solidity.readthedocs.io/en/latest/solidity-in-depth.html)  
[Solidity Style Guide](https://solidity.readthedocs.io/en/v0.4.24/style-guide.html)


## Task 6.2 - Create OpenToken contract
So let's start with a simple token. Create a new contract `OpenToken`.
The contract should have a `public balanceOf` field. The field is of type `mamapping (address => uint256)`
```
mamapping (address => uint256)
```
A mapping means an associative array, where you associate addresses with balances. The addresses are in the basic hexadecimal Ethereum format, while the balances are integers. The public keyword, means that this variable will be accessible by anyone on the blockchain, meaning all balances are public (as they need to be, in order for clients to display them).

## Task 6.3 - Add a constructor
If you published your contract right away, it would work but wouldn't be very useful: it would be a contract that could query the balance of your coin for any address but since you never created a single coin, every one of them would return 0. So we are going to create a few tokens on startup. Create a constructor that accepts a single parameter of type `uint256`. In the constructor, initialze the balance of the address creating the contract with the parameter value `balanceOf[msg.sender] = initialSupply;`

```
balanceOf[msg.sender] = initialSupply;
```

Take a look at the right column beside the contract and you'll see a drop-down list, written pick a contract. Select the `OpenToken` contract and you'll see that now it shows a section called Constructor parameters. These are changeable parameters for your token, so you can reuse the same code and only change these variables in the future.

## Task 6.4 - Transfer
Right now you have a functional contract that created balances of tokens but since there isn't any function to move it, all it does is stay on the same account. So we are going to implement that now. Write the following code before the last bracket.

This is a very straightforward function: it has a recipient and a value as the parameter and whenever someone calls it, it will subtract the _value from their balance and add it to the _to balance. 

```
function transfer(address _to, uint256 _value) public {
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
```

## Task 6.5 - Validate transfer
Right away there's an obvious problem: what happens if the person wants to send more than it owns? Since we don't want to handle debt in this particular contract, we are simply going to make a quick check and if the sender doesn't have enough funds the contract execution will simply stop. It's also to check for overflows, to avoid having a number so big that it becomes zero again.

To stop a contract execution mid-execution you can either return or throw. The former will cost less gas but it can be more headache as any changes you did to the contract so far will be kept. In the other hand, 'throw' will cancel all contract execution, revert any changes that transaction could have made and the sender will lose all Ether he sent for gas. But since the Wallet can detect that a contract will throw, it always shows an alert, therefore preventing any Ether to be spent at all.

```
require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
```

## Task 6.6 - Add description
Add the following fields to the token definition and include them into the constructor:
```
string name;    // Set the name for display purposes
string symbol;  // Set the symbol for display purposes
uint8 decimals;  // Amount of decimals for display purposes
```        
And now we update the constructor function to allow all those variables to be set up at the start.
