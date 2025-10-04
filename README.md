# Terraform
# Alternatives of Terraform
Pulumi (python , Java dev can write their code in same lang, provides CDK to us,(cloud dev kit))
Crossplane
Cloud Formation (Exclusively for AWS)
cloud posse (writes code in TF & sell it to clients)
Open tofu

(In pulumi you can choose the choice of lang/code for creating a Infra )

# Points to be Noted when dealing with Terraform -
1) 100 % of the infra should be provisioned by terraform only.
2) No Manual changes at all.
3) If you do some manual changes, TF will over ride it.
4) Terraform uses HCL as a language.

# Terraform is product from HASHICORP -
IBM has  acquired HASHICORP.

Terraform is cloud Native Tool
Its not created to manage your on-premise Infra.
If your provate cloud is formed on-premise by using VMWare Vsphere or VMWare Tanzua then Terraform supports

# Advantages of using the Terrafrom or IaC -
1) you design the infra once & can use the same across all environments.
2) Entire infra is verion controlled through Git.
3) 0 to none chances of drift between the environment.

# Pros-
1) Faster time to prod releases.
2) Less manual intervention while provisioning or changing the infra.
3) Since there is no manual changes, less errors, more availability
4) Versioned Infra
5) Lower Operation cost
6) Improved consistency

# Cons-
1) More Development, more investment.
2) Achieving non-Functioanl requirement takes time.

# Terraform Files-
1. All TF files should end with .tf or .tf.json as an extension.

2. We can keep multiple files, tf loads them in an alphabetical order, but compiles as per its logic as per the dependencies.
(like first security group, launch ec2, create DNS)
3. you can control using depends_on

# Terraform Version Vs Terraform Providers Version ?
1. Terraform Version

Definition: This refers to the version of the Terraform core tool itself.
Purpose: The Terraform version controls how the Terraform tool behaves, the features it offers, and the internal processing of your infrastructure code

2. Terraform Provider Version

Definition: Terraform Providers are plugins that allow Terraform to interact with different cloud platforms or services (e.g., AWS, Azure, Google Cloud, Kubernetes)
Purpose: The provider version controls which version of the API and features Terraform will use when interacting with that specific service.

