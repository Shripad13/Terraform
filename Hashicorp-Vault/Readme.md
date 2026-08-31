
# Vault - Latest version 2.x - 2.0.4
By HashiCorp
Open Source
Devloped using the Golang
Centralized Secrets & encryption managed system
Identity based - gated by authentication & authorization

 $ ps aux |grep -i vault
 vault will run with vault as user not through root user

# Secrets - Sensitive data
Passwords
PKI certificates
SSH keys
Key Value pairs
API key
Encryption keys (Symmetric and Asymmetric keys )
TIme based OTP
TLC Certs

Symmetric key encryption uses a single shared secret key for both locking (encrypting) and unlocking (decrypting) data, 
whereas asymmetric key encryption uses a mathematically linked pair of keys—a public key to lock and a private key to unlock

# key features of vault
1. Secure Secret Storage
a. Integrated storage - local or consul
b. External storae - AWS, Azure GCP

2. Dynamic Secrets - on demand for AWS, TOTP - time based

3. Data Encryption - Encrypt & Decrypt data without storing it AND Creation encryption keys

4. Leasing And Renewal - 
Lease - allow & revoke secret
Renew - the secret

5. Revocation - based on User, condition 

# Use case 1
General secret storage - Store and Read in plain text
Employee Credential Storage - Create, Manage, Rollout, Revoke
API Key Generation for scripts
Data Encryption

# Use case2 -
Automated PKI Infrastructure - Creating, rotating, managing certificates
Data Encryption & TOkenization - Data across clouds, applications & sytems
Databse Credential Rotation - automated DB credential rotation for apps, services, users
Dynamic Secrets - avoid long live , Generate time based 
Key Management - Centrally manage & automate encryption keys across envs
Kubernetes Secrets - No sharing of creds/token to pods, vault to securely inject secrets to stack.
Secrets Management - key , tokens, across clouds & env


# What is the difference between Vault's KV v1 and KV v2 secrets engines?
The primary difference between Vault's KV v1 and KV v2 secrets engines is data versioning. 
KV v1 acts as a basic key-value store that completely overwrites old values upon new writes, whereas 
KV v2 automatically tracks and preserves a configurable history of secret changes for recovery and rollback.

# Vault Configuration - 
1. HCL or JSON file contains All configuration settings
2. Located at /etc/vault.d/vault.hcl
3. Which has storage, backend, Listener, 

**ByDefault vault is in Seal mode**, you always have to unseal 

Unseal - Key1 will unseal Key2 , key2 wil Unseal Key3 

# Vault Login Steps
Sealed
  |
  |
Enter Portion of Keys
  |
  |
Unseal
  |
  |
Vault Login - Enter Root Key

Vault run on default port - 8200
API Requests - 443 Port
COnsul - Port 8500 - HTTP API


Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit                Interact with audit devices
    auth                 Interact with auth methods
    debug                Runs the debug command
    events
    hcp
    kv                   Interact with Vault's Key-Value storage
    lease                Interact with leases
    monitor              Stream log messages from a Vault server
    namespace            Interact with namespaces
    operator             Perform operator-specific tasks
    patch                Patch data, configuration, and secrets
    path-help            Retrieve API help for paths
    pki                  Interact with Vault's PKI Secrets Engine
    plugin               Interact with Vault plugins and catalog
    policy               Interact with policies
    print                Prints runtime configurations
    proxy                Start a Vault Proxy
    secrets              Interact with secrets engines
    ssh                  Initiate an SSH session
    token                Interact with tokens
    transform            Interact with Vault's Transform Secrets Engine
    transit              Interact with Vault's Transit Secrets Engine
    version-history      Prints the version history of the target Vault server


# Authentication Methods
Generic - Approle, JWT, OIDC, Username/Pwd
Cloud - AWs, Github, GCP, Azure
Infra - k8s, LDAP, Okta

# Vault Authentication flow- 
1. Authenticate- Human User, app role, container
2. Verify he client identity- LDAP,AWS, Azure, GCP, k8s etc 
3. Returns a token with policy attached

# Auth methods
vault auth list
vault auth enable aws
vault token create
vault login token=
vault path-help auth/token
vault auth disable
vault token revoke <token>


# Auth method by userpass
vault auth enable userpass
vault write auth/userpass
vault login -method=userpass username=<>  password=<>
vault auth disable userpass 
vault path-help auth/userpass

# Auth method Github
vault auth list
vault auth enable github
vault write auth/github/config oraganization=<orgname>
vault read auth/github/config 
Create a PAT in github & allow org policies
and login Vault UI using the PAT

Logi using CLI
vault login -method=github token=TOKEN 

vault path-help auth/github
vault write auth/github/map/teams/support value=default
vault write auth/github/map/teams/dev value=dev-policy
vault read auth/github/map/teams/


# Auth Method using AWS

# Differentiate Human vs System
Tokens = for Admins
Github - for developers
LDAP - for users/svc accounts
App role - for machines or apps
k8s - for apps, pods
AWS/GCP/Azure - for apps
JWT - for apps
MFA - for Authorized users


## Secret Engines
Store., Generate or Encrypt the secrets
In the vault, secrets will be stored in a path
Every secret has configuration
Secrets can be **versioned** for KV v2
Every secret has **lease TTL**
Secret has metadata
CRUD operations - Put, list, get , patch, delete, undelete & destroy, rollback

# Vault Secret Lifecycle
Enable --> Move --> Tune --> Disable

vault status
vault login
vault secrets list
vault secrets enable kv 
vault secrets list
vault secrets enable -path=shri kv 

vault kv put shri/webui user=maddi pass=123    ---> you can create
vault kv get shri/webui   ---- you can read
vault kv delte shri/webui
vault secrets disable kv   --> disbale the kv


# Secret Engine KV in versions using kv v2
vault secrets enable -version=2 -path=shripad kv
vault secrets list
vault kv put shripad/webui user=shri pass=257
vault kv put shripad/webui user=shri pass=2573583793

If you see both in Vault UI, you will be able to see in history

vault kv get shripad/webui 
vault kv get -version=1 shripad/webui  ---> you can check versioned KV

vault kv metadata get shripad/webui

vault kv delete -version=1 shripad/webui ===> delete 1st version data
vault kv destroy -version=1 shripad/webui --- > destroyed 
vault kv get version=1

vault secrets disbale shripad/webui

vault secrets list -detailed ----> show in detailed fashion

vault metadata get shri/cus
vault kv metadata put -mount=shri/cus -max-versions 3 -delete-version-after="1h1m1s" kv


# Use Case - HashiCorp Vault- Auto unseal using AWS KMS
Whenever you restart the Vault server, Ec2 instance automatically takes vault keys from AWS KMS to unseal vault

The main purpose of AWS KMS in HashiCorp Vault integration is automatic unsealing (Auto-Unseal), which allows Vault to decrypt its root encryption key at startup without requiring manual operator key shares.

How AWS KMS Integration Works:
Replaces Shamir's Secret Sharing: By default, Vault splits its master key into multiple manual key shares that humans must type in after every restart. AWS KMS removes this operational burden.

Encrypted Master Key: Vault stores its encrypted master key inside its storage backend (such as Consul, Raft, or S3).

Startup Decryption: When Vault boots up, it automatically connects to AWS KMS using pre-configured IAM credentials and requests the decryption of its master key, completing the unseal process instantly

KMS key And Region needs to configured in /etc/vault.d/vault.hcl file

Step 1: Create an AWS KMS Key
Click Create Key.
Select Symmetric and Encrypt and decrypt.
Give it an alias (e.g., vault-auto-unseal).
Define your key administrators and usage permissions, then click Finish.
Copy the Key ID or the ARN (e.g., arn:aws:kms:us-east-1:123456789012:key/12345678-abcd-1234-abcd-123456789abc).

Step 2: Grant Vault IAM Permissions
Attach the following IAM Policy to Vault's execution role (e.g., EC2 Instance Profile or EKS Service Account IAM Role):

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:DescribeKey"
      ],
      "Resource": "arn:aws:kms:us-east-1:123456789012:key/12345678-abcd-1234-abcd-123456789abc"
    }
  ]
}


Step 3: Configure Vault (vault.hcl)

Add the seal "awskms" stanza to your Vault configuration file.

# AWS KMS Auto-Unseal Configuration
seal "awskms" {
  region     = "us-east-1"
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-abcd-1234-abcd-123456789abc"
}

Step 4: Initialize and Verify Vault
 $ vault operator init
Vault will automatically transition to an unsealed state

Step 5: Test Auto-Unseal
1. Run vault status and verify that Sealed is false and Seal Type shows awskms.
 $ sudo systemctl restart vault

Run vault status again. Vault should instantly read Sealed: false without prompting you for keys.

#

###

# Vault Audit Devices 
Whatever you do Authentication , policies and Secret Engines configure that logs will be stream.

1. Detailed Loging Request & Reponse of Logs authneticated intercations, including errors.
2. Can use multiple audit devices (elastic search, Splunk)
3. Can query audit logs
4. Agrgregate/union of the multiple logs from each audit device
   
# Audit Log Format
1. each line is JSON object type
2. will have request and response objects 
3. all the sensitive information is first hashed with HMAC-SHA256 algorithm 
Raw Logging: You can disable hashing for troubleshooting or specific keys via the log_raw=true configuration or -audit-non-hmac-request-keys tuning flags


# Vault Audit Device lifecycle
enable audit device
disable audit device
list enabled audit device

# Vault Audit Device Types
1. File Audit Device - 
   Logs stream into AWS EFS if configured
   Hash sensitive info
   $ vault audit enable file file_path=/var/log/vault_audit.log
    $ vault audit enable file file_path=/var/log/vault_audit.log
2. syslog Audit Device -
   Syslog is a Message Logging standard
   Any device/app can send data about events diagonstics & more 
   Built in severity level - 0 to 6
   syslog server receive, store, interpret syslog message (514 & 601 via UDP)
   514 is the standard default port used to send syslog messages over UDP, while 601 is a misconfiguration because it is reserved exclusively for TCP syslog.

3. Socket Audit Device - 
   communication connection in a network
   Stream socket - HTTP, SSH, FTP etc
   Datagram Socket - DNS, voIP,
   $ vault audit enable socket 

   $ vault audit -h   ====> command for help

# Enable the vault logs

 $ vault audit enable file file_path=/var/log/vault_audit.log
 you will get error bcoz vault run with vault user
 $ touch /var/log/vault_audit.log
 $ chmod 644 /var/log/vault_audit.log
 $ chown vault:vault /var/log/vault_audit.log  
   $ vault audit enable file file_path=/var/log/vault_audit.log
   $ vault audit list
   $ tail -f /var/log/vault_audit.log

   $ vault audit list -detailed
   $ vault audit list -output-curl-string
   $ vault audit  disable file/ 


# Vault Leases - 
1. Lease applicable to only dynamic secret and service type authentication ike LDAP, AWS, etc
2.  Data will be valid for the certain duration or TTL
3. Once lease is expired, vault revokes the data
4. Users of Dynamic secret - should check lease & renew it
5. Dynamic secrets will have lease & lease can be revoked
6. if lease revoked, invalidates the secret & no renewal 
 Ex- AWS secret Engine -> lease revokes -> No Access

 7. when token is revoked --> revokes all leases

# Lease ID can be shown by running below commands:
vault read
vault lease renew
vault lease revoke 



# Vault Deployment Architecture - 

Integrated storage - 
Raft Storage
No additional software required
No need to monitor
Data stored on same host where vault running


External Storage  - 
RDBMS/Dynamo DB, CLoud backends,
For HA, storage should be clustered
Need to monitor & check health
Data stored where external storage is located

# Vault token - 
Core basic method of authentication with in vault
vault login toekn=<token>
Every vault client will use token for vault authentication
Auth methods can be used dynamically generate token
Token is set of one or more attached policies
Every vault system will have initial "root token" (Admin)
             
                1.Authenticate token     2.Verify identity of client
vault Clients --------------> Vault -------------> Trusted Identity Provider
              <---4.Verified------    3.<---Return client token ----

# TOken Types
1. Servie Token - token prefix - hvs.
    Persists service token in vault storage backend
    Renew, revoke service token, child tokens
    root token is belongs to service token type
    Heavyweight - many properties 

2. Batch token - token prefix - hvb.
    DOes not persist- no storage
    lightweight and scalable
    encrypted blobs that carry enough info vault actions
    lack of felxibility and features of service tokens

3. Recovery Token - token prefix - hvr.
    Used when vault runs on recovery mode 


4. Root Token - 
   Generated during $ vault operator init
   Root policy attached
   No expiry, No modification for root token
   For admins, initial setup & not for prod
   Re generate using $ vault operator generate-root

5. Orphan Tokens - 
   Orphan Token is a Vault token that does not have a parent token.
   When you log into Vault and use your token to generate another token, your token becomes the parent, and the new token is the child.
    $ vault token create -orphan
    
# Why Orphan Tokens Are Needed
If an automated system or pipeline logs into Vault, creates a token for an application, and then logs out (or its own token expires), the application's token would instantly die.
An Orphan Token breaks this chain. It sits at the top level of the token tree. Because it has no parent, it will never be accidentally revoked when an upstream process, user session, or CI/CD pipeline expires.

1. What is Vault token rotation, and why is it necessary? Answer: 
Token rotation is the process of periodically replacing existing cryptographic tokens with new ones before they expire. 
It is necessary to adhere to the principle of least privilege,
 reduce the blast radius if a token is leaked, and 
 ensure that stale clients or automated pipelines automatically lose access over time if they are decommissioned.

2. What is the difference between Token Renewal and Token Rotation?Answer:
   Renewal: Extends the lifespan (TTL) of an **existing** token up to its maximum TTL limit. The token string remains exactly the same.
   Rotation: Creates an **entirely new token** string with a fresh time-to-live (TTL) window, and revokes or deprecates the old token.

3. What are the primary types of Vault tokens, and how do they impact rotation?Answer:
    Vault tokens primarily fall into two categories:
    1. Service Tokens: The standard token type. They are written to storage, support renewal, and can have hierarchical child tokens. Rotating them requires managing their explicit TTLs or explicitly revoking them and issuing new ones.
    2. Batch Tokens: Lightweight, ephemeral, non-renewable tokens encrypted in-memory (not written to disk). They cannot be renewed, meaning rotation is forced by design—when a batch token reaches its TTL, the application must authenticate again to get a new one.   
 
 
4. How does an application natively rotate its own Vault token?Answer: 
 An application can manage its own lifecycle using a Renew-and-Replace strategy:
 
 1. The application authenticates via an auth method (e.g., AppRole) and receives a token with an explicit TTL (e.g., 1 hour) and an optional Max TTL.
 2. Background logic in the application checks the token's remaining validity.
 3. If valid and below a specific threshold (e.g., half its life), it calls the /auth/token/renew-self API endpoint.If it hits the Max TTL, renewal is blocked. 
 4. The application must then re-authenticate entirely to fetch a brand new token, effectively completing a rotation cycle.

5. What is the role of the Vault Agent in token rotation, and why is it preferred over native application logic? Answer: 
   Vault Agent Auto-Auth completely offloads token management from application code.
   How it works: 
   The Vault Agent runs alongside the application (e.g., as a sidecar or system daemon). 
   It handles the initial authentication, secures the token, monitors its TTL, automatically renews it, and re-authenticates to grab a new one when the Max TTL is reached.

6. How does Vault handle token lifecycle management when using dynamic cloud auth methods like AWS IAM or Kubernetes? Answer: 
   When apps authenticate via platforms like Kubernetes or AWS IAM, token rotation is natively built into the architectural workflow:
   The application uses its platform identity (e.g., a Kubernetes Service Account Token) to log into Vault.
   Vault validates this identity and hands back a short-lived Vault Service Token.
   Because the platform identities themselves rotate frequently (e.g., Kubernetes service account tokens rotate periodically), the application naturally re-authenticates to Vault using a fresh identity, securing a rotated Vault token seamlessly.

# Kubernetes Pod authenticates with HashiCorp Vault, followed by the actual configuration steps required to set it up.   
Step 1: Enable the Kubernetes Auth Method in Vault
vault auth enable kubernetes

Step 2: Configure Vault to Talk to your Kubernetes API
Vault needs permissions to contact your Kubernetes API server to verify tokens. If Vault is running inside the same Kubernetes cluster, it can auto-configure itself natively:

vault write auth/kubernetes/config \
    kubernetes_host="https://cluster.local"

Step 3: Create a Vault PolicyDefine what the Kubernetes applications are allowed to access. Create a file called app-policy.hcl:

# Allow reading database credentials
path "database/creds/billing-db-role" {
  capabilities = ["read"]
}


vault policy write billing-policy app-policy.hcl

Step 4: Map the Kubernetes Identity to the Vault Policy (The Role)

This is the critical bridging step. You tell Vault: "If a Pod arrives using the Service Account named billing-sa inside the namespace core-apps, issue them a token attached to billing-policy

vault write auth/kubernetes/role/billing-app-role \
    bound_service_account_names=billing-sa \
    bound_service_account_namespaces=core-apps \
    policies=billing-policy \
    ttl=1h

Q. What happens if a developer creates a malicious Pod in a different namespace and tries to spoof the billing-sa name?"
Vault will instantly reject it. Vault validates both the Service Account Name and the Namespace.



vault status
vault operator init
vault operator unseal  XiHFYHCEkbrhbtNlD25KLt1qrrwUCMsm6x8/Fxe/mTtE
vault operator unseal  <Paste Unseal Key 2>
vault operator unseal  <Paste Unseal Key 3>

If you restart ,vault will ask keys with root token
If you logout from vault then it will just ask the root token


# How do you authenticate Vault with AWS
1. Attach IAM role to EC2  --- Create IAM role and add Policy in JSON format
2. Attache the IAM role to EC2 instance
3. sudo systemctl restart vault
4. Use a Real AWS ARN

vault write auth/aws/role/ec2-vault \    
auth_type=iam \
bound_iam_principal_arn=arn:aws:iam::808701193232:role/ec2-vault \
token_policies=my-app-policy

5. Vault will also throw an error if my-app-policy does not exist yet. 
If you haven't created it, create a quick dummy policy so the command succeeds:

# Create a basic policy file
echo 'path "secret/data/*" { capabilities = ["read"] }' > my-app-policy.hcl

# Write it to Vault
vault policy write my-app-policy my-app-policy.hcl


#######################################################33333
# Auth User pass
vault auth enable userpass

#######################################################
vault secrets list
Path               Type              Accessor                   Description
----               ----              --------                   -----------
agent-registry/    agent_registry    agent-registry_471e285b    agent registry
cubbyhole/         cubbyhole         cubbyhole_6cb315b4         per-token private secret storage
identity/          identity          identity_770da56c          identity store
sys/               system            system_a612915b            system endpoints used for control, policy and debugging


ec2-vault = arn:aws:iam::808701193232:role/ec2-vault

arn:aws:kms:us-east-1:808701193232:key/eadb47f1-40ab-40a6-abcd-a690d3873ee1
# AWS KMS Auto-Unseal Configuration
seal "awskms" {
  region     = "us-east-1"
  kms_key_id = "arn:aws:kms:us-east-1:808701193232:key/eadb47f1-40ab-40a6-abcd-a690d3873ee1"
}




########################################################
Share me step by step for HashiCorp Vault auto unseal using AWS KMS
#########################################################