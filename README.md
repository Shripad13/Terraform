# Terraform

>https://www.gruntwork.io/blog/terraform-tips-tricks-loops-if-statements-and-gotchas

~ → in-place update
+ → create
- → destroy
-/+ → destroy & recreate

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


# Terraform Command -
terraform init; terraform plan; terraform apply -auto-approve


## Interview Questons -
1. How are you managing the state file in terraform?
Remote State file manging on top of AWS S3 Bucket with dynamoDB for locking mechanism

State Locking prevents two people or systems from modifying  infrastructure at the same time.
Imagine a simple visual:
First apply start
State get locked
Second apply start ( waits for the lock to be released )
Lock released after first apply is done
Second apply continues

# Most remote backends support locking automatically:
AWS S3 with DynamoDB (AWS)
Google Cloud Storage with native locking (GCP)
Azure Blob Storage with native locking (Azure)
Terraform Cloud or Enterprise (HashiCorp)



1. Why Terraform, as you're already on AWS, why are you not using CloudFormation?
We are also using some 3rd party products like conflunce, mongoDB
Also we have planned to use Multi-Cloud Approach
With CloudFormation only AWS specific services can be used.
Terraform has close to 5000 proivders & Procider agnoistic tool.
Terraform plan gives us a clear picture of what changes are going to be made before applying it.


1. if you're tf state is corrupted, what would you do?
Always enable versioning on s3 bucket & simply go back to previous verison of state file.



4. What is the Terraform drift & how do you handle it.?
Whenever Infra is created by Terraform code is disturbed by human
Whenver drift comes up & make sure that change is intended or not 
then go & try to run & accept the drift.

5. What is tf.state & tf.state.backup

terraform.tfstate tracks the real infrastructure which Terraform manages
terraform.tfstate.backup is the automatically created previous version used for recovery.

1. How to delete tf cache?
 remove the cache (rm -rf .terraform) in local

1. how do you list the object that are created by Terraform when you are in repo?
terraform init
terraform state list 

terraform state rm <obejct_name>   ------ for eliminate the object from state

8. What is a provisioner & null resource in tf?
Provisoner - if we want to execute something on remote instance 
Provisoners always executed on the resource Creation.
null resource - 
A null_resource in Terraform is a special resource that doesn’t create or manage any real infrastructure.
It is mainly used to run actions or scripts as part of a Terraform workflow.

A null_resource is a Terraform resource that manages no infrastructure and is used to run provisioners or scripts based on triggers.

What is a null_resource?
A placeholder resource
Used to attach provisioners (like shell scripts)
Executes actions based on triggers
Does not create cloud resources (EC2, S3, etc.)

Example- 

resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello Terraform"
  }
}


9. WHy provisioners are reffered as create time provisioners?
Provisioners will only run during creation of resources
from 2nd time it will refreshes  
If we want to execute for every time then use trigger.

10. how can we make sure that provisioners are executed all the time you run tf plan/apply ?
We have triggers - By mentioning this provisioners are executed all the time 

11. How can we ensure that tf wont destory resources accidentally ?
## Terraform LifeCycle -
1. create_before_destory ----> before destorying it will create bcoz avoiding downtime
This is useful for resources that cannot be updated in-place or where downtime must be minimized during updates 

2. prevent_destroy = true
If you attempt to destroy a resource with prevent_destroy = true, Terraform will return an error, safeguarding critical infrastructure like production databases

3. ignore_changes ---> This argument takes a list of resource attributes that Terraform should ignore when determining if a change has occurred. 


1. Use lifecycle Block with prevent_destroy = true
2. Use Environment-Specific Permissions (IAM)
3. Use terraform plan with Manual or Automated Review
5. Use State Locking

Enable remote state + locking to prevent multiple people from applying:
S3 + DynamoDB (AWS)
GCS + locking (GCP)
Terraform Cloud or Enterprise

This prevents conflicting changes that might destroy resources.

6. Use terraform apply -refresh-only or plan -refresh=false When Validating
This prevents Terraform from acting on drift during validation steps

7. Use Resource Policies (Cloud-Specific Protective Features)
Below Prevents the instance from being terminated via the AWS API.

resource "aws_instance" "prod" {
  instance_type          = "t3.micro"
  ami                    = "ami-123"

  disable_api_termination = true
}

12. how do you integrates AWS S3 with DynamoDB for state locking mechanism?

S3 → stores the state file (the shared source of truth)
DynamoDB → provides a distributed lock so only one process can modify the state at a time

Client / CI Job / App
        |
        | 1. Acquire lock
        v
  DynamoDB (Lock Table)
        |
        | 2. Read / Write state
        v
      S3 Bucket
        |
        | 3. Release lock
        v
  DynamoDB (Lock Table)

terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}


# Your production apply is STUCK because Terraform wants to DELETE and RECREATE an entire VPC - even though you changed only one tag.”

𝐓𝐡𝐞 𝐒𝐜𝐞𝐧𝐚𝐫𝐢𝐨 -
Terraform wants to recreate a whole VPC because of a force-new argument triggered by:
• Changing CIDR
• Changing DHCP options
• Changing certain tags depending on provider version
• Drift in manually created associations (e.g., route tables attached outside TF)

In this case: a minor tag update caused Terraform to detect a dependency cycle → force recreation.

ANSWER - 
𝟏. 𝐅𝐢𝐫𝐬𝐭, 𝐢𝐝𝐞𝐧𝐭𝐢𝐟𝐲 𝐖𝐇𝐘 𝐓𝐞𝐫𝐫𝐚𝐟𝐨𝐫𝐦 𝐰𝐚𝐧𝐭𝐬 𝐭𝐨 𝐫𝐞𝐜𝐫𝐞𝐚𝐭𝐞 𝐭𝐡𝐞 𝐕𝐏𝐂
 He ran:
 terraform plan -out plan.tfplan
 And then:
 terraform show plan.tfplan

He checked the diff to see which attribute had 𝐅𝐨𝐫𝐜𝐞𝐍𝐞𝐰 = 𝐭𝐫𝐮𝐞.
This is where most candidates fail - they never check attribute-level diff.

𝟐. 𝐅𝐫𝐞𝐞𝐳𝐞 𝐭𝐡𝐞 𝐕𝐏𝐂 𝐭𝐨 𝐚𝐯𝐨𝐢𝐝 𝐫𝐞𝐜𝐫𝐞𝐚𝐭𝐢𝐨𝐧
He created a lifecycle block inside the VPC resource:

lifecycle {
 prevent_destroy = true
 ignore_changes = [
 tags,
 dhcp_options_id
 ]
}

This 𝐢𝐧𝐬𝐭𝐚𝐧𝐭𝐥𝐲 𝐬𝐭𝐨𝐩𝐬 𝐓𝐞𝐫𝐫𝐚𝐟𝐨𝐫𝐦 from destroying anything in that VPC.
This is the move only an experienced engineer knows.

𝟑. 𝐅𝐢𝐱 𝐝𝐫𝐢𝐟𝐭 𝐛𝐲 𝐢𝐦𝐩𝐨𝐫𝐭𝐢𝐧𝐠 𝐨𝐫𝐩𝐡𝐚𝐧𝐞𝐝 𝐝𝐞𝐩𝐞𝐧𝐝𝐞𝐧𝐜𝐢𝐞𝐬
He knew the root cause:
Someone created/modified associated resources manually using AWS console.

So he used:
 terraform import aws_route_table.public rt-12345
 terraform import aws_main_route_table_association.main rta-12345

Once all dependencies were inside TF state, the plan became clean.

𝟒. 𝐑𝐞-𝐫𝐮𝐧 𝐭𝐡𝐞 𝐩𝐥𝐚𝐧 𝐚𝐟𝐭𝐞𝐫 𝐬𝐭𝐚𝐛𝐢𝐥𝐢𝐳𝐢𝐧𝐠 𝐝𝐫𝐢𝐟𝐭
After importing resources + adding ignore_changes, the VPC was no longer flagged for recreation. 

𝟓. 𝐏𝐞𝐫𝐦𝐚𝐧𝐞𝐧𝐭 𝐟𝐢𝐱: 𝐌𝐨𝐯𝐞 𝐭𝐚𝐠𝐬 𝐢𝐧𝐭𝐨 𝐚 𝐬𝐞𝐩𝐚𝐫𝐚𝐭𝐞 𝐦𝐨𝐝𝐮𝐥𝐞
To avoid this issue in future, he split the VPC into:
• 𝐜𝐨𝐫𝐞_𝐯𝐩𝐜 𝐦𝐨𝐝𝐮𝐥𝐞 (never touched, stable)
• 𝐯𝐩𝐜_𝐭𝐚𝐠𝐬 𝐦𝐨𝐝𝐮𝐥𝐞 (safe to update anytime)
This eliminated accidental ForceNew events on critical infra.

𝐅𝐢𝐧𝐚𝐥 𝐀𝐧𝐬𝐰𝐞𝐫 𝐇𝐞 𝐆𝐚𝐯𝐞 𝐭𝐡𝐞 𝐈𝐧𝐭𝐞𝐫𝐯𝐢𝐞𝐰𝐞𝐫
“I would never let Terraform recreate a production VPC.
I would inspect why ForceNew is triggered, freeze destruction with lifecycle rules, import missing dependencies, stabilize drift, and only then safely apply the change.”


## What Are Terraform Workspaces?
Workspaces are multiple isolated state files for the same Terraform configuration.

main.tf variables.tf outputs.tf 

Workspaces:
 default → state #1
 dev   → state #2
 qa   → state #3
 prod  → state #4

👉 Same code, different state.

👉 Different infra, created from the same template.

🛠️ Creating & Using Workspaces

1️⃣ Create a workspace: terraform workspace new dev
2️⃣ Switch to it: terraform workspace select dev
3️⃣ View the current workspace: terraform workspace show
4️⃣ Use it in code:
 resource "aws_s3_bucket" "demo" {
 bucket = "myapp-${terraform.workspace}"
 }
 If workspace = dev → bucket = myapp-dev
 If workspace = qa → bucket = myapp-qa
 This avoids collisions and keeps infra clean.

🌍Use Case #1
 Creating ephemeral review environments for each PR
 Imagine each pull request needs a temporary environment:

 Before testing:
 terraform workspace new pr-143
 terraform apply

 After testing:
 terraform destroy
 terraform workspace delete pr-143

🔹 No long-term cost
 🔹 No manual cleanup
 🔹 Works perfectly in CI/CD

Use Case #2
Explain this 💼 Real-World Use Case #2
Multi-tenant environments using the same code

Example: 50 client deployments.

Instead of copying 50 repos:

terraform workspace new client_a
terraform workspace new client_b
terraform workspace new client_c

Then use workspace name dynamically:

locals {
 tenant = terraform.workspace
}

resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidrs[local.tenant]
}

🔹 1 repo
🔹 50 isolated states
🔹 No duplication
🔹 Fully scalable

🔥Use workspaces for short-lived environments, NOT for production.
 Why? 
 Because this can happen:
 terraform workspace select default
 terraform apply
 ❌ Oops — you just deployed to the wrong environment.
Production needs:
 ✔ Separate backend bucket
 ✔ Separate state lock table
 ✔ Separate access control
 ✔ Separate pipelines
Use workspaces for parallelism, not governance.

When NOT to Use Workspaces

Not every case is a workspace case ❗

❌ Do NOT use for prod if you need:
Strong IAM separation
Separate backends
Approval workflows
Compliance guardrails
Use separate directories/repos for those.

Workspaces = convenience
Prod = safety first


## What is Terraform CONSOLE?
Terraform console is an interactive way that lets you evaluate Terraform expressions using your current configuration and state.
It’s mainly used to test variables, functions, and expressions without running terraform apply.

2. terraform state list
 → Verifies what resources are tracked in the remote state.
3. terraform state pull (my favourite)
 → Pulls the remote state file and displays it in JSON format.
 → Useful for inspection and manual state backups.

# Terraform bootstrapping
Terraform bootstrapping is the process of creating the initial infrastructure and permissions Terraform needs to manage the rest of your infrastructure.
Terraform cannot manage these resources until they exist, so they must be created first — this is the “bootstrap” phase.
# Terraform often relies on resources that don’t exist yet, such as:
A remote backend (e.g., S3 + DynamoDB, GCS, Azure Storage) to store state file
IAM users, roles, or permissions Terraform needs to run
Networking or org-level configuration
A CI/CD runner or execution environment

# Terraform Folder structure for large projects:  
├── modules/                # Reusable Terraform modules
│   ├── network/            # Network module (VPC, subnets, etc 
│   ├── compute/            # Compute module (EC2, ASG, etc)  
│   └── database/           # Database module (RDS, DynamoDB, etc)
├── envs/                   # Environment-specific configurations 
│   ├── dev/                # Development environment
│   │   ├── main.tf         # Main Terraform configuration for dev 
│   │   ├── variables.tf    # Variables for dev environment
│   │   └── backend.tf      # Backend configuration for dev 
│   ├── staging/            # Staging environment
│   │   ├── main.tf         # Main Terraform configuration for staging
│   │   ├── variables.tf    # Variables for staging environment
│   │   └── backend.tf      # Backend configuration for staging
│   └── prod/               # Production environment
│       ├── main.tf         # Main Terraform configuration for prod
│       ├── variables.tf    # Variables for prod environment
│       └── backend.tf      # Backend configuration for prod
├── scripts/                # Helper scripts (e.g., bootstrap, deploy)
├── .gitignore              # Git ignore file
├── README.md               # Project documentation
├── terraform.tfvars        # Common variables file (if any)
└── providers.tf            # Provider configurations (AWS, GCP, etc)

# What will happen if your Infrastructure has been deleted manually & you run infra provisioning pipeline again?
Terraform will detect that the resources defined in the state file are missing from the actual infrastructure. When you run the provisioning pipeline again, Terraform will attempt to recreate those missing resources to bring the infrastructure back to the desired state as defined in your Terraform configuration files. This ensures that any manual deletions are corrected and the infrastructure remains consistent with the code.

# How will you setup notification if your pipeline fails while provisioning infra using Terraform?
To set up notifications for pipeline failures during Terraform infrastructure provisioning, you can integrate your CI/CD pipeline tool (like Jenkins, GitLab CI, GitHub Actions, etc.) with a notification service (like email, Slack, Microsoft Teams, etc.). Here’s a general approach: 
1. Configure your CI/CD pipeline to include a notification step that triggers on failure.
2. Use built-in notification plugins or webhooks to send alerts to your chosen communication channel.
3. Customize the notification message to include relevant details about the failure, such as error logs or links to the pipeline run.
4. Test the notification setup to ensure that alerts are sent correctly when the pipeline fails.
5. Monitor and adjust the notification settings as needed to avoid alert fatigue while ensuring critical issues are communicated promptly.
6. Mail notification plugin in jenkins, Slack notification plugin in jenkins etc.,
7. Use AWS SNS to send notifications on pipeline failure.
8. Use Terraform Cloud’s built-in notification system if you are using Terraform Cloud for state management and runs.
9. Set up monitoring tools like Datadog, PagerDuty, or Opsgenie to alert on pipeline failures.



#  In which scenarios , terraform will destroy & recreate a resources in AWS cloud?

1. You change an attribute marked ForceNew
Some resource arguments are immutable in AWS. When they change, Terraform has no choice but to replace the resource.

Examples-
1. EC2 - subnet_id , availability_zone , ami
2. EBS - availability_zone
3. RDS - engine , db_subnet_group_name
4. VPC - cidr_block
5. ALB - load_balancer_type (application ↔ network)

2. You change the resource name / identifier
Many AWS resources treat the name as immutable.
Examples -
1. aws_s3_bucket.bucket
2. aws_db_instance.identifier
3. aws_iam_role.name
4. aws_lb.name
Even though it feels cosmetic, AWS sees this as “new resource”.

3. You change the resource type
Example:
resource "aws_instance" "web" { ... }
→ changed to: resource "aws_launch_template" "web" { ... }
old resource deleted, new resource created

4. Changes to count / for_each
Example -
count = 3
→ changed to: count = 2
Terraform will destroy one instance.

More dangerous case: If the order of var.subnets changes → wrong instance destroyed.
Example - count = length(var.subnets)

Best Practise - for_each = toset(var.subnets)

5. Resource removed from configuration
  If resource disappears from .tf files, Terraform assumes it’s no longer desired.
  Terraform will destroy it on apply.

6. lifecycle rules that force replacement
  lifecycle {
  create_before_destroy = true
}

This still destroys the old resource — just after the new one is ready.

7. Provider or Terraform version changes
This can trigger unexpected replacements during terraform plan.
👉 Always read provider changelogs before upgrading.

8. Drift detected in AWS
If someone changes the resource outside Terraform and the attribute is immutable, Terraform must replace it.

Example:
EC2 instance moved to a different subnet manually (rare, but possible via recreate)
RDS engine modified manually

Terraform sees: actual state ≠ desired state → replace

9. Importing existing resources incorrectly
If the imported resource doesn’t match the configuration exactly, Terraform may plan a replace.
Example: terraform import aws_instance.web i-12345
But the .tf file has: ami = "ami-xyz"
Terraform: “This isn’t the same instance” → replace.

10. Explicit -replace flag
You can force it yourself: terraform apply -replace="aws_instance.web"


# Pro tips to avoid accidental destruction
1. Use for_each instead of count
2. Use Lifecycle rules to prevent destruction
lifecycle {
  prevent_destroy = true
}