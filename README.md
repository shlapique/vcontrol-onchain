# Version Control system 

## How to deploy

```
forge script script/Deploy.s.sol --broadcast --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY
```

this will deploy BaseContract with first or `init` implementaion of some contract

## Upgrade contract

After deploying base version we should get the address of `vControl` contract:

```
...
vControl deployed at: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
...
```

After paste this into command

```
forge script script/t/Upgrade.s.sol --broadcast --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY --sig "run(address)" 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
```

## Rollback

To check current version call:

```
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "getCurrentVersion()" --rpc-url http://localhost:8545
```

to Rollback:

```
cast send 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "rollbackTo(uint256)" 0 --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY
```

to get version history call:

```
cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "getVersionHistory()" --rpc-url http://localhost:8545
```

and you'll something similar to this:

```
0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000020000000000000000000000005fbdb2315678afecb367f032d93f642f64180aa30000000000000000000000009fe46736679d2d9a65f0992f2272de9f3c7fa6e0
```
