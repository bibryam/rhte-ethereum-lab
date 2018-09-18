pragma solidity ^0.4.0;

contract HelloWorld {
    event log_string(bytes32 log);

    function () { // Fallback Function
        log_string("Hello World!");
    }
}