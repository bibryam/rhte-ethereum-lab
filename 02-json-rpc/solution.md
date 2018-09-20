# JSON-RPC API

## Task 4 - Interact with the ethereum network

- Find the current network Id
```
curl https://mainnet.infura.io/v3/bda837d7e4044d6c8b5b89691c9e262e \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"net_version","params": [],"id":1}'
```

- Find the node version
```
curl https://mainnet.infura.io/v3/bda837d7e4044d6c8b5b89691c9e262e \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"web3_clientVersion","params": [],"id":1}'
```

- Find latest block number
```
curl https://mainnet.infura.io/v3/bda837d7e4044d6c8b5b89691c9e262e \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params": [],"id":1}'
```

Convert from hex to decimal:  
```printf "%d\n" 0x60f972 ``` => 6355314
 
 - Find the balance of the following account: 0xc94770007dda54cF92009BFF0dE90c06F603a09f
``` 
 curl https://mainnet.infura.io/v3/bda837d7e4044d6c8b5b89691c9e262e \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","method":"eth_getBalance","params": ["0xc94770007dda54cF92009BFF0dE90c06F603a09f", "latest"],"id":1}' 
```

Convert from hex to decimal:  
```printf "%d\n" 0x1f89871578b14c``` => 8876937551851852 Wei => 0.008876937551851852 Ether
