
# What is the difference between Vault's KV v1 and KV v2 secrets engines?
The primary difference between Vault's KV v1 and KV v2 secrets engines is data versioning. 
KV v1 acts as a basic key-value store that completely overwrites old values upon new writes, whereas 
KV v2 automatically tracks and preserves a configurable history of secret changes for recovery and rollback.