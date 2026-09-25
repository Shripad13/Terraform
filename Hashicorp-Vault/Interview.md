
# 1. Tell me about your experience with HashiCorp Vault.

"My primary experience is in DevOps, cloud infrastructure, CI/CD, Infrastructure as Code and enterprise automation. My direct hands-on experience with HashiCorp Vault is not as extensive as my experience with Terraform, Ansible, Kubernetes and CI/CD.

However, I understand Vault from the perspective of secrets management and its integration with modern DevOps platforms. I understand concepts such as authentication methods, policies, secrets engines, dynamic secrets, token management, Kubernetes authentication and cloud-based authentication.

My experience with RBAC, GitHub Enterprise, Kubernetes, Terraform, cloud platforms and enterprise production environments gives me a strong foundation for working with Vault. I'm particularly interested in the application-onboarding side of Vault, where authentication, authorization, secret lifecycle management and automation come together."


2. What is HashiCorp Vault and why would an enterprise use it?

"HashiCorp Vault is a centralized secrets-management and identity-based access platform. It allows organizations to securely store, generate, access and rotate sensitive information such as passwords, API keys, database credentials, certificates and tokens.

The important point is that applications don't need to have long-lived credentials hardcoded in source code, configuration files or CI/CD pipelines.

Vault provides authentication, authorization through policies, secrets engines, auditing and, where applicable, dynamic credentials.

In a large enterprise such as a bank, this becomes particularly important because you need centralized control, least-privilege access, credential rotation, auditability and standardized onboarding across a large application estate."


3. Explain Vault architecture.

A good senior-level answer:

"At a high level, Vault has several important components.

First is the authentication layer, which establishes who or what is requesting access.

Then we have policies, which determine what that identity is allowed to access.

Then we have secrets engines, which manage the actual secrets or generate dynamic credentials.

Vault also provides audit logging so that access to secrets can be monitored and investigated.

In an enterprise deployment, Vault itself would normally be deployed in a highly available architecture, with appropriate storage, TLS, operational monitoring, backup and disaster-recovery considerations."

4. What is the difference between authentication and authorization in Vault?

This is very important for this role.

"Authentication answers the question: Who are you?

Authorization answers: What are you allowed to access?

In Vault, an application might authenticate using Kubernetes authentication, AWS IAM authentication or AppRole.

After successful authentication, Vault associates the identity with policies. Those policies determine which paths and operations the identity can perform."


5. What are Vault authentication methods?
   Token AppRole Kubernetes AWS Azure LDAP OIDC JWT TLS certificates

Vault supports multiple authentication methods depending on the identity source.

For example, Kubernetes authentication allows workloads running in Kubernetes to authenticate using their Kubernetes service account identity.

AWS authentication can use AWS identity mechanisms.

AppRole is commonly used for machine-to-machine authentication when an application isn't naturally represented by another identity provider.

OIDC or LDAP can be used for human authentication.

7. What are Vault secrets engines?

"Secrets engines are components within Vault that store, generate or manage secrets.

For example, KV can store static key-value secrets, while database secrets engines can generate dynamic database credentials.

Other engines can be used for PKI certificates, cloud credentials and other types of secrets.

The important distinction is that different secrets engines provide different capabilities and lifecycle models."

9. What is a Vault policy?

"A Vault policy defines what an authenticated identity is allowed to do.

Policies are path-based and can control capabilities such as read, create, update, delete and list.

I would follow least privilege, meaning an application should receive access only to the paths and operations it actually requires."



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


24. What is Vault auto-unseal?

Traditionally, Vault requires an operator process to unseal it after startup. Auto-unseal allows Vault to use an external key-management mechanism to automate that process.

In cloud environments, this can integrate with services such as cloud KMS.

The key benefit is reducing manual operational dependency while maintaining appropriate key-management controls.

25. What is the difference between Vault and a password manager?
 A password manager primarily focuses on storing and retrieving credentials for users.

Vault is designed for programmatic secrets management and identity-based access for applications and infrastructure.

Vault can also generate dynamic credentials, issue certificates, integrate with cloud and Kubernetes identities, enforce policies and provide auditability."


Q5: What is the native high-availability (HA) storage backend recommended by HashiCorp, and how does it work?
Answer: HashiCorp recommends Integrated Storage (Raft). 
Instead of relying on external databases (like Consul or AWS S3), Vault handles its own storage and replication. 
It uses the Raft consensus protocol across a cluster of nodes (typically 3 or 5), where one node is elected the Leader (processing all writes) and the others act as Standby nodes.

Q6: Why should you immediately revoke or stop using the Initial Root Token after setting up a production Vault environment?
Answer: 
The Initial Root Token has absolute privileges, cannot be restricted by standard policies, and does not expire. 
Leaving it active poses a severe security risk. 
The industry best practice is to use it only to configure initial Auth Methods and Admin Policies, create a standard admin account, and then immediately revoke the root token.


Q1: What is a "Dynamic Secret" in Vault, and how does it differ from a "Static Secret"?
Answer:
A Static Secret (like KV v2) is defined ahead of time, stays the same until a human manually updates it, and is shared among users or applications.
A Dynamic Secret does not exist until an application requests it. Vault connects to the target system (e.g., AWS, a database) on-the-fly, generates a brand-new, unique credential with a strict Time-to-Live (TTL), and automatically deletes (revokes) it when it expires.

Q2: Walk me through the life cycle of a dynamic database secret from generation to expiration.Answer: The life cycle follows four distinct phases:

Configuration: An administrator configures a database secrets engine with root connection details and defines a "role" (the SQL template for new users).

Request: An application authenticates to Vault and reads the role path (e.g., vault read database/creds/my-app).

Generation: Vault dynamically executes the SQL script on the database, creates a unique user account, and hands the credentials + lease ID back to the application.

Revocation: When the lease TTL expires (or if explicitly revoked early), Vault automatically connects back to the database and runs a script to drop or disable that specific user account.


Q3: What is a Vault "Lease ID," and why is it critical for dynamic secrets?Answer: 
A Lease ID is a unique tracking identifier that Vault attaches to every dynamic secret it generates. It does not contain the secret itself, but acts as a receipt. 
Vault uses this Lease ID to track the secret’s age, allow applications to renew it, and accurately target that specific credential for destruction during the revocation process.


Q4: How do you configure Vault to generate dynamic credentials for a PostgreSQL database? Summarize the main steps.Answer: 
The setup requires three main steps:
Enable the Engine: vault secrets enable databaseConfigure 
Connection: Give Vault the root database connection URL and administrative credentials so it has permission to manage users.
Create a Role: Define a role mapped to a specific SQL statement. 
For example:
sql
CREATE USER "{{name}}" WITH PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";


# How do you configure Vault to generate dynamic credentials for an Oracle DB?

1. Download and Register the Plugin: Ensure your vault.hcl has a defined plugin_directory. Download the Oracle Database Plugin binary from HashiCorp, place it in that directory, and register it:

      vault plugin register \
         -sha256="<PLUGIN_BINARY_SHA256>" \
         database vault-plugin-database-oracle

2. Prepare the Oracle DB Administrative User
   
   Vault requires a dedicated static database user with high privileges to execute user management statements (CREATE USER, GRANT, DROP USER). 
   Log into your Oracle instance as an administrator and provision a VAULT_ADMIN user:

'''
   CREATE USER vault_admin IDENTIFIED BY "ComplexAdminPassword123#";
   GRANT CREATE USER, ALTER USER, DROP USER TO vault_admin WITH ADMIN OPTION;
   GRANT CREATE SESSION TO vault_admin WITH ADMIN OPTION;
   -- Vault needs session termination privileges to clean up users immediately upon lease expiration
   GRANT ALTER SYSTEM TO vault_admin; 


'''


3. Enable the DB secret Engine
   $ vault secrets enable database 

4. COnfigure the Oracle DB Connection
   Provide vault with connection details and administrative credentialsso it can create and drop users in your oracle DB. 
   Use "vault-plugin-database-oracle" as the plugon name.

  vault write database/config/oracle-db \
      plugin_name="vault-plugin-database-oracle" \
      allowed_roles="app-read-write" \
      connection_url="{{username}}/{{password}}@//oracle-server-hostname:1521/ORCLPDB1" \
      username="vault_admin" \
      password="ComplexAdminPassword123#"

5. Rotate the root credentials immediately so that the administrative password is randomized and known only by Vault:
      vault write -force database/rotate-root/oracle-db


5. Define a Dynamic Role

   vault write database/roles/app-read-write \
      db_name="oracle-db" \
      creation_statements="CREATE USER \"{{name}}\" IDENTIFIED BY \"{{password}}\"; GRANT CREATE SESSION TO \"{{name}}\"; GRANT SELECT, INSERT, UPDATE ON my_schema.my_table TO \"{{name}}\";" \
      revocation_statements="ALTER SYSTEM KILL SESSION '...'; DROP USER \"{{name}}\" CASCADE;" \
      default_ttl="1h" \
      max_ttl="24h"

6.  Fetch Dynamic Credentials
  $  vault read database/creds/app-read-write


Q5: What happens if a database is down or unreachable when a dynamic secret's TTL expires? How does Vault behave?Answer: 
If the target system is down, Vault's background revocation manager will fail to delete the credential. Vault will log a revocation error and keep retrying the deletion at periodic intervals (backed by an exponential backoff strategy). The secret remains tracked in Vault's lease storage as "failed revocation" until the database comes back online and the drop command succeeds.


Q6: If an application needs a dynamic secret to last longer than its initial 1-hour TTL, what must the application do, and what constraint will it hit?Answer:
 The application must proactively call the Vault renew endpoint (vault lease renew <lease-id>) before the 1-hour window closes. However, it can only extend the lease up to the Maximum TTL configured on that Vault secrets engine or role. Once it hits the Max TTL, renewal is blocked, and the application must request an entirely new dynamic secret.


Q1: What is a Vault Secret Engine, and what is its primary purpose?
Answer: 
A Secret Engine is a component in Vault that handles storing, generating, or encrypting data. Vault handles different data types by using different engines. 
They are isolated at specific URL paths (e.g., kv/, aws/, database/) and can be enabled, disabled, tuned, or moved independently.

Q2: What is the difference between the Key/Value (KV) Version 1 and Version 2 secret engines?
Answer:
KV Version 1: A simple storage engine that only retains the current, active value of a secret. Writing new data completely overwrites the old data.
KV Version 2: An advanced storage engine that automatically provides secret versioning and history. It allows you to roll back to old secrets, recover deleted keys (undelete), and permanently destroy data using a "purge" operation.

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
Answer: 
The LDAP auth method delegates authentication to an external directory service (like Active Directory).
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


# Scenarios based questions:

# When a HashiCorp Vault dynamic secret engine stops working for a CI/CD pipeline and is fixed by a simple restart, it usually points to an underlying issue with resource exhaustion, credential synchronization, or connection pooling.

WHy it stopped working:
1. Lease/Token Limit Exhaustion
2. Stale or Broken Connection Pools - Vault maintains internal connection pools to talk to target systems 
3. Target API Rate Limiting: 
   
How the Restart Fixed It :
1. Restarting Vault immediately flushed its active memory, dropped broken connection pools, and re-initialized fresh connections to your target infrastructure.
2. If you are running Vault in a High Availability (HA) cluster, a restart forces a new leader election. This shifts the workload to a healthy node and forces a full state resynchronization with the storage backend.
3. Reset Internal Timeouts & Caches
How to Prevent It From Happening Again:
1. un vault monitor or check your system logs (like journalctl) around the exact time of the failure to find the specific error message (e.g., context deadline exceeded or lease limit reached).
2. Optimize TTLs (Time-to-Live): Ensure your dynamic secrets have short default and maximum TTLs. 
3. Implement Rolling Cleanups: Ensure your CI/CD pipelines explicitly revoke their leases upon completion instead of waiting for the TTL to expire.


# Application is getting HTTP 403 from Vault. How do you troubleshoot?

“I would first separate authentication from authorization. 
A 403 generally makes me investigate authorization rather than immediately assuming the Vault service is unavailable. 
I would verify which identity authenticated, 
which role and policies were applied, 
whether the requested secret path is correct, 
whether the correct secrets-engine mount and KV version are being used, and 
whether the policy grants the required capability. 
I would also use audit logs to correlate the request.”

1. Confirm application identity
        ↓
2. Confirm authentication succeeded
        ↓
3. Identify Vault token / role
        ↓
4. Check attached policies
        ↓
5. Verify secret path
        ↓
6. Check KV v1 vs KV v2 path
        ↓
7. Check policy capabilities
        ↓
8. Check namespace/mount
        ↓
9. Review Vault audit logs
        ↓
10. Reproduce with controlled test

# What if authentication itself fails?

Application
   |
   v
Network/TLS - certificate & network connectivity, DNS lookup 
   |
   v
Auth Method - Identify which Auth method used
   |
   v
Role / Identity - Role assignment and check policies, role binding, role exists or not?
   |
   v
Vault - Check vault audit logs


# Vault security questions?
Least privilege -
Give the application only the exact paths and operations it requires.

Secret exposure -
Never:
hardcode secrets in Git
put secrets into Docker images
print secrets into logs
store secrets in CI/CD artifacts
expose secrets unnecessarily as environment variables

Credential lifecycle - 
Create --> Use --> rotate --> renew --> revoke --> Audit

# What if Compromised credential -

"I would first determine the scope and potential impact of the compromised token.

I would revoke the token and investigate what resources it could access.

I would review audit logs for suspicious activity, rotate any potentially exposed credentials, and determine whether other identities or systems were affected.

After containment, I would perform root-cause analysis and implement preventive controls to reduce the possibility of recurrence


29. What is the principle of least privilege in Vault?

"An identity should have only the permissions required to perform its intended function.

For example, if an application only needs to read a database password, I wouldn't give it administrative access to the secrets engine.

I'd scope the policy to the required path and capability and periodically review whether that access is still required."

# Why is certificate lifecycle management important? PKI
Certificates are security credentials, so their lifecycle needs to be managed from issuance through renewal and revocation. 
Expired certificates can cause outages, while poorly protected private keys can create security exposure. 
Automation helps maintain consistent renewal, monitoring and rotation.


30. How does PKI fit with Vault?

Vault's PKI secrets engine can act as a certificate authority and issue certificates programmatically.

Instead of manually creating and distributing certificates, applications can request certificates based on an authorized identity and role.

This can help automate certificate issuance and lifecycle management, including expiration and renewal.

For an enterprise environment, I would still integrate this with the organization's certificate policies, trust hierarchy and compliance requirements.


31. How would you handle certificate expiry?

I would avoid treating certificate renewal as a manual operational activity.

I'd establish monitoring around certificate expiration and, where possible, automate certificate issuance and renewal through the appropriate PKI platform.

I'd also test renewal before expiry and make sure dependent applications can reload certificates without unnecessary service disruption."

# Zero Trust and Identity Security
Zero Trust is based on the principle that access should not be trusted simply because a workload or user is inside the network. 
Access should be continuously evaluated based on identity, authentication, authorization, device or workload context and least privilege.

# How would you onboard thousands of applications?

At that scale, manual onboarding would not be sustainable. 
I would standardize the onboarding model around application metadata, ownership, environment, authentication pattern, secret classification and policy templates. 
Then I would automate the repeatable components using Terraform and CI/CD, while maintaining approval and security controls. 
I would also create reference architectures, onboarding documentation and troubleshooting playbooks so application teams can follow a consistent process

# What if developers don't want to onboard to Vault?
I would first understand the reason for the resistance—whether it is integration complexity, delivery timelines, operational concerns or lack of understanding. 
I would explain the security and operational benefits, but I would also focus on making the secure approach easier to adopt. 
For example, I would provide a standard integration pattern, reusable Terraform components and clear documentation. 
The objective would be to establish a controlled and repeatable onboarding process rather than simply asking teams to change their workflow


18. What is AppRole?
   AppRole is a machine-oriented authentication method designed primarily for applications and automation.

It uses a Role ID and Secret ID, and Vault uses those credentials to authenticate the application.

The important security consideration is how the Secret ID is delivered and protected. I wouldn't simply hardcode it into application source code."

19. What is Vault lease?
A lease represents the validity period associated with certain Vault-generated credentials or secrets.

When the lease expires, the credential may be revoked depending on the secrets engine and configuration.

Applications can renew leases where supported, or obtain new credentials when required.


20. How do you rotate secrets?
I would first identify whether the secret is static or dynamic.

For static credentials, I would establish an automated rotation mechanism and ensure dependent applications can consume the new value safely.

For dynamic credentials, Vault can manage the credential lifecycle through leases and revocation.

The important part is ensuring that rotation doesn't create an outage. I would therefore test the complete lifecycle, including credential generation, application retrieval, transition and rollback or recovery.


21. What happens if Vault is unavailable?
The exact behavior depends on the application's integration model and caching strategy.

I would first distinguish between applications that retrieve secrets at startup and those that retrieve or renew them continuously.

From the Vault platform perspective, I would design for high availability, appropriate storage, monitoring, backups and disaster recovery.

At the application level, we need to carefully consider whether secrets can be safely cached temporarily and what the application's failure behavior should be.

I would avoid simply recommending indefinite caching because that can undermine the security objective.

22. How would you design Vault for high availability?
I would deploy Vault as a highly available cluster with multiple nodes and a supported HA storage architecture. I'd place appropriate load balancing in front of the cluster and ensure TLS is enforced.

I'd also design backup and disaster recovery separately from HA because HA addresses node or service failure, whereas DR addresses larger failure scenarios.

Monitoring, audit logging, certificate management and operational runbooks would also be part of the design."

23. What is the difference between HA and DR?

"High availability is primarily about maintaining service availability when individual components fail.

Disaster recovery is about recovering the service and data after a larger failure such as regional or site-level disruption.

HA doesn't replace DR. For a critical banking platform, I would design and test both."


26. How does Vault fit into Zero Trust?

"Vault fits well into a Zero Trust model because access is based on verified identity and explicit authorization rather than simply trusting the network location.

An application authenticates using a trusted identity, receives only the permissions required through policy, and obtains the specific secret it needs.

This supports principles such as least privilege, short-lived credentials and continuous identity-based access."


33. How would you secure Vault itself?

"I would approach Vault security at multiple layers: strong authentication, least-privilege policies, TLS, secure token management, audit logging, controlled administrative access, secure storage, key-management controls, network segmentation, monitoring and regular access reviews.

I would also ensure that Vault configuration is managed through controlled processes and that administrative operations are auditable."


35. How would you handle a developer who asks for broad Vault access?

"I would first understand the actual business and technical requirement rather than simply granting the requested access.

I would identify the minimum paths and capabilities required and create a least-privilege policy around that requirement.

If broader access genuinely requires approval, I would follow the organization's security and access-governance process rather than bypassing it."


36. How would you balance developer productivity and security?

"I don't see security and developer productivity as mutually exclusive.

The objective should be to make the secure path the easiest path.

For example, instead of asking every development team to manually manage credentials, we can provide a standardized Vault onboarding process with reusable policies, automation and documentation.

That gives developers a predictable process while maintaining centralized security controls."


37. How would you create a Vault onboarding program?


"I would standardize the onboarding process into clearly defined stages:

Application registration → ownership validation → authentication method → policy template → secret path → integration → testing → security validation → production approval → monitoring.

I would automate as much of this as possible using Terraform and CI/CD while retaining appropriate approval gates.

I'd also maintain documentation and onboarding templates so that different teams follow the same secure pattern."

38. What would you automate with Terraform vs Ansible?

"I would generally use Terraform for declarative infrastructure and platform configuration where supported, including Vault configuration that benefits from infrastructure-as-code and version control.

I would use Ansible more for configuration management and operational workflows.

I wouldn't force everything into one tool. The choice should depend on the lifecycle and ownership of the resource."


40. Why should we hire a DevOps engineer for a security/Vault role?

This is a question I would prepare very carefully because it addresses your biggest profile gap.

"My background is primarily DevOps and cloud engineering, but I believe that experience is directly relevant to this role because modern secrets management is deeply integrated with application delivery and infrastructure.

I've worked with Terraform, Ansible, Kubernetes, CI/CD, cloud platforms, Linux, GitHub Enterprise, RBAC and enterprise production environments.

That means I understand the environments in which Vault needs to operate—not just Vault as an isolated security product.

I also understand the importance of automation, least privilege, reliability, traceability and controlled change.
My goal is to bring that engineering background into the security domain and build deeper specialization in secrets management, privileged access and identity security.