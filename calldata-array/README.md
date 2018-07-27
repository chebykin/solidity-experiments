# Calldata Array

## Question
How many array items could be passed into solidity function through ABI?

## Answer
No limits for array items to be passed, but there is a block limit.

~250 items require ~6.5M gas (for ex. current mainnet block limit is 8M gas)