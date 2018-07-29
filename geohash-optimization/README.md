# Geohash Optimization

## Question
What type of geohash to binary encoding consumes less gas and storage amount than others?

## Answer
Test results:

```
string
storage slot: 0x73657a653739326b683337350000000000000000000000000000000000000018
 gas: 43546

-----------------

      ✓ should set string variable (51ms)
bytesString
storage slot: 0x73657a653739326b683337350000000000000000000000000000000000000000
 gas: 42483

-----------------

      ✓ should set bytesString variable (43ms)
bytesInt >>> 42161
bytesInt
storage slot: 0x061bf69e45280ce5
 gas: 42161

-----------------

      ✓ should set bytesInt variable (40ms)
int
storage slot: 0x061bf69e45280ce5
 gas: 42117

-----------------

      ✓ should set int variable
```