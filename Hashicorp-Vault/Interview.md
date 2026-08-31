
Q1: What are the two primary server modes you can run Vault in, and what is the difference between them?Answer:
1. Dev Mode (-dev): A lightweight setup meant for testing and development. 
   It runs entirely in memory, automatically unseals itself, 
   listens on HTTP (no TLS), and loses all data when restarted. Never use this in production.

2. Prod Mode: The secure setup for real environments. 
   It requires a backend configuration file (vault.hcl), forces HTTPS/TLS compliance, starts in a sealed state, and writes data to a persistent storage backend.

Q2: What does it mean to "Initialize" a Vault cluster, and what two critical items are generated during this step?Answer: 

Initialization is the process of setting up Vault's storage backend for the first time and generating its cryptographic master key. During this step, Vault outputs:
1. Unseal Keys (or Key Shares): A set of cryptographic keys used to unseal Vault.
   
2. Initial Root Token: The ultimate, unrestricted token used to configure Vault for the first time.

Q3: What is Shamir's Secret Sharing algorithm, and how does Vault use it by default during initialization?Answer: 
Shamir's Secret Sharing is an algorithm that splits a single secret into multiple unique parts.
By default, Vault uses it to split its Master Key into 5 unseal key shares. 

To unseal Vault and reconstruct the Master Key, a specific threshold—usually 3 of those 5 shares—must be provided by different key holders.


Q4: What is the difference between a "Sealed" and an "Unsealed" Vault server?
Answer:

1. Sealed: The default state when a Vault server boots up. 
   In this state, Vault knows where its data is, but cannot read it because the master decryption key is wrapped. Vault will reject all API requests except those used to unseal it.
   
2. Unsealed: The active state.
    Once the threshold of unseal keys is met, Vault loads the master key into RAM, decrypts its storage, and can fully process read/write secrets operations.

Q5: What is the native high-availability (HA) storage backend recommended by HashiCorp, and how does it work?
Answer: HashiCorp recommends Integrated Storage (Raft). 
Instead of relying on external databases (like Consul or AWS S3), Vault handles its own storage and replication. 
It uses the Raft consensus protocol across a cluster of nodes (typically 3 or 5), where one node is elected the Leader (processing all writes) and the others act as Standby nodes.

Q6: Why should you immediately revoke or stop using the Initial Root Token after setting up a production Vault environment?
Answer: The Initial Root Token has absolute privileges, cannot be restricted by standard policies, and does not expire. 
Leaving it active poses a severe security risk. 
The industry best practice is to use it only to configure initial Auth Methods and Admin Policies, create a standard admin account, and then immediately revoke the root token.


Q1: What is a "Dynamic Secret" in Vault, and how does it differ from a "Static Secret"?Answer:A Static Secret (like KV v2) is defined ahead of time, stays the same until a human manually updates it, and is shared among users or applications.A Dynamic Secret does not exist until an application requests it. Vault connects to the target system (e.g., AWS, a database) on-the-fly, generates a brand-new, unique credential with a strict Time-to-Live (TTL), and automatically deletes (revokes) it when it expires.

Q2: Walk me through the life cycle of a dynamic database secret from generation to expiration.Answer: The life cycle follows four distinct phases:Configuration: An administrator configures a database secrets engine with root connection details and defines a "role" (the SQL template for new users).Request: An application authenticates to Vault and reads the role path (e.g., vault read database/creds/my-app).Generation: Vault dynamically executes the SQL script on the database, creates a unique user account, and hands the credentials + lease ID back to the application.Revocation: When the lease TTL expires (or if explicitly revoked early), Vault automatically connects back to the database and runs a script to drop or disable that specific user account.


Q3: What is a Vault "Lease ID," and why is it critical for dynamic secrets?Answer: A Lease ID is a unique tracking identifier that Vault attaches to every dynamic secret it generates. It does not contain the secret itself, but acts as a receipt. Vault uses this Lease ID to track the secret’s age, allow applications to renew it, and accurately target that specific credential for destruction during the revocation process.


Q4: How do you configure Vault to generate dynamic credentials for a PostgreSQL database? Summarize the main steps.Answer: 
The setup requires three main steps:
Enable the Engine: vault secrets enable databaseConfigure 
Connection: Give Vault the root database connection URL and administrative credentials so it has permission to manage users.
Create a Role: Define a role mapped to a specific SQL statement. 
For example:
sql
CREATE USER "{{name}}" WITH PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";


Q5: What happens if a database is down or unreachable when a dynamic secret's TTL expires? How does Vault behave?Answer: If the target system is down, Vault's background revocation manager will fail to delete the credential. Vault will log a revocation error and keep retrying the deletion at periodic intervals (backed by an exponential backoff strategy). The secret remains tracked in Vault's lease storage as "failed revocation" until the database comes back online and the drop command succeeds.


Q6: If an application needs a dynamic secret to last longer than its initial 1-hour TTL, what must the application do, and what constraint will it hit?Answer: The application must proactively call the Vault renew endpoint (vault lease renew <lease-id>) before the 1-hour window closes. However, it can only extend the lease up to the Maximum TTL configured on that Vault secrets engine or role. Once it hits the Max TTL, renewal is blocked, and the application must request an entirely new dynamic secret.


Q1: What is a Vault Secret Engine, and what is its primary purpose?
Answer: 
A Secret Engine is a component in Vault that handles storing, generating, or encrypting data. Vault handles different data types by using different engines. 
They are isolated at specific URL paths (e.g., kv/, aws/, database/) and can be enabled, disabled, tuned, or moved independently.

Q2: What is the difference between the Key/Value (KV) Version 1 and Version 2 secret engines?Answer:KV Version 1: A simple storage engine that only retains the current, active value of a secret. Writing new data completely overwrites the old data.KV Version 2: An advanced storage engine that automatically provides secret versioning and history. It allows you to roll back to old secrets, recover deleted keys (undelete), and permanently destroy data using a "purge" operation.

Q3: If an organization needs to dynamically generate TLS certificates on demand without managing a separate Microsoft or open-source CA infrastructure, which secret engine should they use?
Answer: 
They should use the PKI (Public Key Infrastructure) Secret Engine. 
This engine allows Vault to act as a Root or Intermediate Certificate Authority (CA).
Applications can dynamically request x509 certificates and private keys on the fly, significantly reducing the operational overhead of certificate management.

Q4: What happens to the data stored under a secret engine path if you run the 
vault secrets disable <path> command? Answer: 
Disabling a secret engine instantly revokes all active leases and permanently deletes all data and configuration stored at that path. 
The data cannot be recovered unless you restore it from a backup, so this command must be used with extreme caution.

Q5: Can you enable the same type of secret engine (e.g., KV v2) multiple times on a single Vault server? If yes, how?
Answer: Yes. 
 
 $ vault secrets enable -path=kv-dev kv-v2
 $ vault secrets enable -path=kv-prod kv-v2


Q6: Explain the basic function of the Transit Secret Engine. How does it handle data storage?Answer: 
The Transit engine provides Cryptography-as-a-Service. It handles encryption, decryption, signing, and verification of data on-the-fly. 
Crucially, Transit does not store the data it encrypts. Applications send plaintext to Vault, and Vault immediately returns the ciphertext without saving anything to its backend storage.


Q1: What is the purpose of a Vault Authentication Method, and what does Vault return upon a successful login?Answer:
 An Auth Method is the component responsible for verifying a user or application’s identity (checking who they are). 
 Upon a successful login, Vault always returns a Vault Token mapped to specific access policies that define what actions that entity can perform.

Q2: Can you enable the same Auth Method multiple times on a single Vault cluster? Give a practical example.Answer: 
Yes. Just like secret engines, auth methods can be enabled multiple times by mounting them to distinct paths.

 $ vault auth enable -path=ldap-corp ldap
 $ vault auth enable -path=ldap-contractors ldap


Q3: What is AppRole authentication, and what are the two core credentials required to log in with it?Answer: 
AppRole is a machine-to-machine authentication method designed for applications, scripts, or CI/CD pipelines. 
It requires two distinct pieces of information to authenticate:
Role ID: acts as the application's "username" (usually static).
Secret ID: acts as the application's "password" 


Q4: How does the LDAP Auth Method validate user credentials, and does Vault store the user's password?
Answer: The LDAP auth method delegates authentication to an external directory service (like Active Directory).
When a user logs in, Vault securely passes the username and password to the LDAP server for verification. 
Vault never stores the user's password; it only retains the mapping of LDAP groups to Vault policies.

Q5: Explain how TLS Certificate Authentication works in Vault. When is it typically preferred?Answer: 
TLS Certificate Authentication authenticates clients using trusted SSL/TLS client certificates. Instead of typing a password or token, the client presents their certificate during the TLS handshake. 
Vault verifies that the certificate was signed by a trusted Certificate Authority (CA) configured in Vault. 
It is highly preferred in secure, static infrastructure environments where machines already possess managed certificates.


Q6: Name at least three "Other" major authentication mechanisms natively supported by Vault for cloud environments.
Answer:
1. Kubernetes: Uses native pod Service Account tokens to authenticate applications running inside Kubernetes clusters.

2. AWS: Validates IAM signatures or EC2 instance metadata to authenticate cloud resources natively.

3. OIDC / JWT: Integrates with modern Identity Providers (like Okta, Azure AD, or Keycloak) to provide Single Sign-On (SSO) for human users.