1. Check current Terraform and provider versions
2. Review compatibility and release notes
3. Back up state and prepare rollback
4. Install the target Terraform CLI
5. Run terraform init; use -upgrade only when intended
6. Run terraform fmt -check and terraform validate
7. Run terraform plan and review changes
8. Apply the approved plan
9. Verify infrastructure, versions, and Git changes

3. How to explain the activity in an interview
   
In my project, Terraform upgrades were handled through a controlled change-management process.

First, I checked the existing Terraform CLI version, provider versions, and module dependencies. Then I reviewed the release notes and compatibility requirements for the target version.

Before making changes, I created a Git branch, ensured that the Terraform state was backed up securely, and planned the rollback procedure. We tested the upgrade in a lower environment before moving to production.

Next, I upgraded Terraform on the relevant developer machines or CI/CD runners and updated the version constraints in the configuration where required. I ran terraform init to initialize the working directory and used terraform init -upgrade only when we intentionally needed to upgrade providers or modules.

After initialization, I ran terraform fmt and terraform validate, generated a Terraform plan, and reviewed it carefully for unexpected resource changes, replacements, or deletions.

Once the plan was approved, we applied the changes through the deployment pipeline. Finally, we verified the Terraform and provider versions, checked infrastructure health, reviewed the resulting plan, and committed the required configuration and lock-file changes to Git.

The main objective was to upgrade Terraform without introducing unexpected infrastructure changes or compromising the state file.

2. Example Terraform upgrade in a real project
   
Suppose your team currently uses Terraform 1.5.x and wants to upgrade to 1.9.x. The exact versions are illustrative.

Update the Terraform version constraint
In versions.tf: 
terraform {
  required_version = ">= 1.9.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

This allows Terraform CLI versions from 1.9.0 up to, but not including, 2.0.0. The AWS provider constraint is a separate version constraint and should be changed only if you intend to change the provider version.



1. Step-by-step Terraform upgrade activity
   
   The key is to explain the activity in this order:

Check current version → Review changes → Backup state → Upgrade version → Initialize → Validate → Plan → Apply → Verify.


# 1. Check current versions
terraform version
terraform providers

# 2. Back up state through the approved process
terraform state pull > terraform-state-backup.json

State backup caution: terraform state pull outputs sensitive state data. Store the backup securely and restrict access. With a remote backend, use the backend's approved backup and recovery procedure as well.

# 3. Install and select the target Terraform CLI version
terraform version

# 4. Initialize using existing locked provider versions
terraform init

# 5. Validate
terraform fmt -check
terraform validate

# 6. Review proposed infrastructure changes
terraform plan -out=tfplan
terraform show tfplan

# 7. Apply only after approval
terraform apply tfplan

# 8. Verify
terraform plan



Q1. What is the difference between terraform init and terraform init -upgrade?

> terraform init initializes the backend and installs dependencies, normally reusing provider selections from the lock file. terraform init -upgrade allows Terraform to select newer provider and module versions within applicable constraints. 


Q2. Will upgrading Terraform recreate existing resources?

> Not necessarily. Upgrading the CLI alone does not automatically recreate infrastructure. However, changes in provider behavior, configuration compatibility, or resource schemas can result in proposed changes. Always review the plan before applying.

Q3. What is .terraform.lock.hcl?

> It records selected provider versions and checksums to help maintain consistent provider installations across team members and CI/CD environments. It should normally be committed to Git. 


Q4. What if terraform plan shows unexpected resource destruction?

> I would stop the deployment, inspect the plan and configuration changes, check for provider behavior changes or infrastructure drift, and resolve the issue before requesting approval again.

Q5. How do you roll back a failed Terraform upgrade?

> I would follow the tested rollback plan, restore the previously approved CLI and dependency versions, and revert the relevant code changes if appropriate. I would not blindly restore an old state file over a live state because that could cause state and infrastructure to become inconsistent.

Q6. How do you upgrade Terraform in a CI/CD pipeline?
> I would update the pinned Terraform version in the pipeline image, tool installer, or version manager; test the pipeline in a lower environment; preserve the dependency lock file; run validation and plan checks; and deploy through the normal approval process.



# terraform upgrade activity steps and how to tell them in interview

In my project, we manage infrastructure across multiple AWS accounts using Terraform and a CI/CD pipeline.

First, we configure cross-account IAM roles in the target accounts and allow our deployment identity to assume those roles using temporary credentials.

We maintain reusable Terraform modules for resources such as VPCs, subnets, security groups, and EC2 instances. We pass environment-specific variables for Dev, QA, and Production.

For deployments, we either use separate Terraform runs with separate state files for each account or use **AWS provider aliases** when we need to manage multiple accounts in a single configuration.

Our pipeline validates the code, generates Terraform plans, and deploys to the required accounts. Production deployments require approval before applying the changes.

Finally, we verify the resources in each AWS account and ensure that state is stored securely and independently for each environment.

This approach helps us automate multi-account deployments, maintain consistency, enforce access controls, and reduce manual errors.