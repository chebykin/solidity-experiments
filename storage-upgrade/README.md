# Storage Upgrade

# Question
Could logic contract overwrite his address in a proxy storage? Provide an example of a such case.

# Answer
Yes, it's possible. Just store a logic contract address in a proxy storage in slot 3. This slot could be overriden by a logic contract if it operates with a storage slot 3.