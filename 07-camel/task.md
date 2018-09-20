# Ethereum Oracle based on Apache Camel

Run Camel based oracle following this sample
https://github.com/bibryam/camel-ethereum-oracle

## Task 10.1 - Deploy the following contract
```
pragma solidity ^0.4.23;

contract Oracle {
    // Contract owner
    address public owner;

    // BTC Marketcap Storage
    uint public btcMarketCap;

    // Callback function
    event CallbackGetBTCCap();

    constructor() public {
        owner = msg.sender;
    }

    function updateBTCCap() public {
        // Calls the callback function
        emit CallbackGetBTCCap();
    }

    function setBTCCap(uint cap) public {
        // If it isn't sent by a trusted oracle
        // a.k.a ourselves, ignore it
        require(msg.sender == owner);
        btcMarketCap = cap;
    }

    function getBTCCap() constant public returns (uint) {
        return btcMarketCap;
    }
}
```

## Task 10.2 - Run event listener

## Task 10.2 - Run event triggering transactions
