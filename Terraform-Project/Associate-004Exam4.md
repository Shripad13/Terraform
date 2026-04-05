

# You must ensure Terraform always installs the same Azure provider release during initialization. Which configuration correctly pins the provider?
Your answer is correct
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.51.0"
    }
  }
}
Explanation
This is the correct configuration for ensuring a specific version of the Azure provider is used by Terraform. This is achieved by defining the "required_providers" block within the terraform block and specifying the version of the provider.

#  Import existing infrastructure into your Terraform workspace

After successfully importing an existing resource using an import block and running terraform apply, you can immediately delete the import block from your configuration file without affecting Terraform's ability to manage the resource.

Once an import block has been successfully processed by terraform apply, the resource is added to Terraform's state file, and the import block has served its purpose. The import block is only needed during the import operation itself. After the resource is in state, Terraform manages it through the corresponding resource block, not the import block. You can safely remove import blocks from your configuration after the import is complete - in fact, removing them is recommended to keep your configuration clean. The resource will continue to be managed by Terraform as long as the resource block remains in your configuration.

#  Explain how Terraform uses and manages state

In most cases, Terraform allows you to move the state between supported backends at any time, even after running the initial terraform apply. This flexibility is useful for changing the backend configuration to meet evolving requirements or to accommodate different infrastructure setups without losing the state data.

You can change your backend configuration at any time. You can change both the configuration itself and the type of backend (for example, from "consul" to "s3"). However, there may be limitations when migrating certain backends to others. For example, you may not be able to migrate from HCP Terraform to a local backend, as this may not be supported.

Terraform will automatically detect any changes in your configuration and prompt you to reinitialize. As part of the reinitialization process, Terraform will prompt you to migrate your existing state to the new configuration. This allows you to easily switch from one backend to another.


# Your AWS infrastructure configuration deploys a load balancer and several EC2 instances. Your security team wants to audit which resources were created and obtain their IDs for documentation. You're deciding whether to add output blocks to your configuration. What is the primary benefit of using output blocks for this purpose?
output blocks in Terraform allow you to selectively expose specific resource attributes, such as resource IDs, without the need for others to parse the entire state file.

#  Configure and use HCP Terraform integration
 You can continue using your local Terraform CLI to execute terraform plan and terraform apply operations while using HCP Terraform as the backend. HCP Terraform acts as a remote backend where state files are stored and managed, but it does not restrict you from using your local Terraform CLI for executing Terraform commands.

 If you have migrated or configured your state to use HCP Terraform using the backend configuration, you can continue using your local Terraform CLI to execute operations while using HCP Terraform. You can even specify the workspace in which you want to execute the operation.

To configure the backend to use HCP Terraform, you can add something like this:

terraform {
  cloud {
    organization = "bryan"
 
    workspaces {
      tags = ["app"]
    }
  }
}

# You're creating three GCP Compute Engine instances that must be placed in the same subnet. The subnet was created by another resource in your configuration. What's the correct approach to ensure all three instances use the same subnet?

You should reference the same subnet resource's attribute (such as google_compute_subnetwork.main.self_link) in all three instances. 
Using the same reference in multiple resources is a common pattern in Terraform.

Referencing the subnet resource's id attribute in each instance's network interface block ensures that all three instances are placed in the same subnet. This approach establishes a direct relationship between the instances and the subnet, guaranteeing that they are correctly configured to use the specified subnet.

# A junior engineer studying for their Terraform Associate exam asks when they should enable verbose Terraform logging. In which of the following scenarios is enabling verbose logging most appropriate?
1. Enabling verbose Terraform logging is most appropriate "when investigating unexpected changes during a plan operation" because it provides detailed information about the resources being created, updated, or deleted.
2. Enabling verbose logging is crucial "when provider API calls are failing" as it allows the engineer to see the exact requests and responses being sent between Terraform and the provider. This visibility can help pinpoint the root cause of the failures and troubleshoot more effectively.
3. when troubleshooting state locking issues to understand which operations are attempting to acquire the lock


# Which CLI commands will completely tear down and delete all resources that Terraform manages in the current workspace?
> terraform apply -destroy      ---> It just a alias command for below command
> terraform destroy      

# You must destroy and recreate only one database server managed by Terraform without editing the configuration. Which command should you run?

> terraform apply -replace="aws_instance.database"

Use -replace=ADDRESS with plan/apply to tell Terraform to destroy the selected resource and create a new one in the same run. You can pass multiple -replace flags and use full addresses, including module paths. It is safer and more predictable than targeting or manual destroy steps.

# You have a set of city names, but the module input expects a list of strings. Which expression correctly converts the set to a list?

variable "cities" {
  type    = set(string)
  default = ["pune", "goa", "austin", "agra"]
}

Your answer is correct -
module "trip" {
  source       = "./modules/trip"
  city_list    = tolist(var.cities)
}
Explanation
The tolist() function is used to convert a set to a list in Terraform. In this scenario, using tolist(var.cities) correctly converts the set of city names to a list, which aligns with the module input requirement.

1. The values() function works on maps and objects, not sets, so values(var.cities) is not valid here.
2. The flatten() function in Terraform is used to flatten a list of lists into a single list. It is not suitable for converting a set to a list, so using flatten(var.cities) would not achieve the desired conversion in this scenario.
3. Accessing var.cities[0] directly retrieves the first element of the set, which is not the correct approach to convert a set to a list.

> A set is an unordered collection of unique strings, while a list is ordered. 
> When a module expects a list, convert with tolist(var.cities). If you need a predictable order, wrap it with sort(tolist(var.cities)) to avoid non-deterministic element ordering.

# Manage module versions
In Terraform, you cannot specify multiple version constraints for a single module by using the version argument multiple times in the module block. The version argument can only be specified once in the module block to define a single version constraint for that module.

You cannot specify the version argument multiple times in a module block. Instead, you combine multiple constraints into a single version string separated by commas, 
such as version = ">= 1.0.0, < 2.0.0". 
This single version string can contain multiple constraint expressions, logically ANDed together. Each constraint is evaluated, and the version must satisfy all of them.

# Given the variable below, which expression returns the string r2d2?

variable "robots" {
  type    = list(string)
  default = ["jarvis", "data", "r2d2", "ultron", "glaDOS"]
}

Your answer is correct
> var.robots[2]

 The correct way to access the third element in the list of strings stored in the variable robots is by using var.robots[2]. In Terraform, list elements are accessed using zero-based indexing, so var.robots[2] corresponds to the string r2d2.

# Which Terraform feature lets you transform, combine, and derive values for use in resource arguments?
Correct answer
> expressions with built-in functions
Expressions with built-in functions in Terraform "allow you to transform, combine, and derive values" for use in resource arguments. 
These functions provide powerful capabilities to manipulate data and generate dynamic values within your Terraform configuration.

Terraform’s expression language and built-in functions (for example, join, format, lookup, tolist, conditionals, and for expressions) allow you to compute values dynamically before passing them to resources. 

Variables and outputs move data between modules & are used to store and retrieve values.

Providers manage APIs, Providers manage the lifecycle of a resource.

provisioners are used for tasks like bootstrapping or configuration management.

Root modules and child modules in Terraform are organizational constructs that help structure your configuration.

but expressions and functions perform the actual value transformation.

# When using Terraform, where can providers be installed from?
From Terraform’s perspective, official install sources are:

1. public registry,
2. private/external registries,
3. local mirrors/cache,
4. HCP Terraform private registry.

Terraform installs providers from various sources depending on how your CLI configuration and provider source addresses are defined. The most common is the Terraform Registry, which hosts both official and community providers. Organizations can host private registries that follow the same registry protocol for internal or custom providers. For air-gapped or controlled environments, Terraform supports filesystem and HTTP(S) mirrors that serve as local or networked sources for provider binaries.

The plugin cache, while useful for reusing previously downloaded providers, isn’t an installation source -Terraform never installs from the cache. 
Similarly, manually placing binaries in a directory or downloading them from release pages bypasses Terraform’s version and checksum management. Configuring proper registry or mirror sources ensures provider integrity, predictable installs, and compliance with the intended Terraform workflow.

# A platform team manages multiple HCP Terraform workspaces across various environments, each configured for a different repository. They want to define cloud credentials and common tags once, store them in a single location, and have those updates automatically apply to all workspaces in the project.
What feature should the team use?

> create a variable set in HCP Terraform and assign it to all workspaces so shared credentials are updated
This allows for shared credentials to be updated centrally and automatically applied to all workspaces in the project, ensuring consistency and efficiency in managing multiple environments.

# Steve needs to gather detailed information about an EC2 instance that he deployed earlier in the day. What command can Steve use to view this detailed information?

Your answer is correct
> terraform state show aws_instance.frontend
to view detailed information about the EC2 instance he deployed earlier.

> terraform show aws_instance.frontend
used to provide an overview of the Terraform configuration and state. It does not specifically show detailed information about a single resource like an EC2 instance.


# You execute Terraform runs from a CI pipeline and must move an existing resource from Stack A’s state to Stack B’s state without destroying it. Which two configuration blocks enable this configuration-driven workflow? 
Correct selection
> removed block in the source stack
The removed block instructs Terraform to remove a resource from state. When you remove a resource from state, Terraform no longer manages the actual infrastructure that the configuration represents.
Correct selection
> import block in the destination stack
The import block in the destination stack allows you to import an existing resource into the state of the destination stack without destroying it. This enables you to move the resource from one stack to another without losing any existing data or configurations.

Incorrect selection -
1. moved block in the destination stack
   The moved block specifies the previous address and the new address for the resource. But it only moves it within the same state file, not across different state files.

2. lifecycle block in the source stack
   The lifecycle block in the source stack is not specifically used to move an existing resource from one stack to another. The lifecycle block is typically used to define specific behaviors for a resource, such as preventing it from being destroyed or updated under certain conditions. 

# You want to use the new features available in Terraform 1.12.0 and change the required_version constraint in your configuration to ~> 1.12.0. After committing and pushing the change, your HCP Terraform run fails with an error stating that the Terraform version does not meet the required_version constraint. What is the most likely cause of this error?
> The Terraform version setting in HCP Terraform workspace is still set to an older version and needs to be updated to 1.12.0 or later.
In HCP Terraform, updating the required_version constraint in your configuration file is not sufficient to upgrade the Terraform version used for runs. The workspace has its own Terraform version setting that controls which version HCP Terraform actually uses to execute plans and applies. If you update required_version to ~> 1.12.0 but the workspace is still configured to use an older version, the run will fail because the workspace version does not satisfy your configuration's requirement.

To resolve this, you must update the workspace's Terraform version setting in the HCP Terraform UI to 1.12.0 or later. This two-step process ensures intentional version upgrades and prevents accidental changes to the execution environment.


# You're creating an AWS RDS database instance and need to provide an initial administrator password. You want to retrieve the password during the apply operation and ensure it's never stored in the state file. Which approach correctly implements this?
Your answer is correct
Add an ephemeral block to retrieve the password, such as:



ephemeral "vault_kv_secret_v2" "db_password" {
  mount = "secret"
  name  = "db_creds"
}
 
resource "aws_db_instance" "database" {
  password = ephemeral.vault_kv_secret_v2.db_password.data["password"]
}

Adding an ephemeral block to retrieve the password from a secure storage like Vault ensures that the password is not stored in the Terraform state file. By referencing the password from the ephemeral block, you can retrieve it during the apply operation without persisting it in the state file, enhancing security.

> Ephemeral values are retrieved during Terraform operations but are never persisted to the state file. This is ideal for sensitive data like passwords that you need to use during resource creation but don't want stored. 
> The ephemeral block retrieves the password from Vault only during the apply operation, uses it to create the database, and then discards it. The password never appears in your state file, providing better security than data sources or random resources that would store it in state.
>

# Password should NOT be stored/ retrieved in following ways - 

1. Using a sensitive variable only hides the value during Terraform plan and apply operations, but it still gets stored in the state file.
   Add a new variable for the password with the sensitive flag, such as:
   > var.db_password

2. Using a data source to retrieve the password from a secure storage like Vault is a secure approach, but it does not ensure that the password is never stored in the Terraform state file. The retrieved password will still be part of the state file, potentially compromising security.
   Use a data source to retrieve the password, such as:
   > data.vault_kv_secret_v2.db_password.data["password"]

3. The random_password resource generates a password but does not provide a mechanism to securely retrieve and use it without storing it in the state file.
   Use the random_password resource, such as:
   > random_password.db_password.result


# You have declared a variable named db_connection_string inside of the app module. However, when you run a terraform apply, you get the following error message:



Error: Reference to undeclared input variable
 
on main.tf line 35:
4: db_path = var.db_connection_string
 
An input variable with the name "db_connection_string" has not been declared. This variable can be declared with a variable "db_connection_string" {} block.
Why would you receive such an error?

Answer : since the variable was declared within the module, it cannot be referenced outside of the module

When using modules, it's common practice to declare variables outside of the module and pass the value(s) to the child module when it is called by the parent/root module. 
However, it's perfectly acceptable to declare a variable inside a module if you need to. Any variables declared inside a module are only directly referenceable within that module. You can't directly reference that variable outside of the module. You can, however, create an output in the module to export any values that might be needed outside of the module.


# terraform graph
The terraform graph command is used to generate a visual representation of either a configuration or execution plan. The output is in the DOT format, which can be used by GraphViz to generate charts.

# You need to rotate a database instance to a new one without downtime. The instance name is immutable, so a new instance must be created before the old one is destroyed, and the replacement should be triggered whenever the subnet resource is replaced. Which lifecycle configuration meets both requirements?
Question 26 
Your answer is correct
resource "db_instance" "main" {
  # ...
  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [aws_subnet.app]
  }
}

Explanation
This configuration specifies that a new database instance should be created before the old one is destroyed, meeting the requirement of rotating the database instance without downtime. Additionally, the replacement of the instance should be triggered whenever the subnet resource is replaced, ensuring that the database instance stays in sync with the subnet resource changes.


# Assigning individual user permissions directly to each workspace without using teams can lead to a lack of centralized control and difficulty in managing permissions at scale. It is not a recommended approach for managing permissions in HCP Terraform.
1. Use organization-level permissions to control administrative access to settings and policies
2. Create teams and assign workspace-level permissions to control which teams can plan or apply changes
3. Configure project-level team access to apply permissions across multiple workspaces

# Your company uses AWS for production and Azure for development, and currently uses CloudFormation for AWS and ARM templates for Azure. What is the main benefit of switching to Terraform for both cloud platforms?

Terraform provides a consistent workflow across different cloud providers through its unified configuration language (HCL) and common commands, such as plan, apply, and destroy. This means teams only need to learn one tool, rather than mastering CloudFormation for AWS, ARM templates for Azure, and Deployment Manager for Google Cloud. While the resource types differ between clouds, the process of writing, reviewing, and deploying infrastructure remains the same, reducing training time and operational complexity.


# After running terraform init in a new working directory, Thomas wants a dry run that saves the result for a later apply without creating resources. Which command should he use?
> run terraform plan -out=thomas


# Your company currently provisions Azure workloads with ARM templates, but is expanding to AWS and an on-premises Kubernetes cluster. Leadership wants a single workflow and minimal retraining across platforms. Which approaches best leverage Terraform’s multi-cloud, service-agnostic model? 
1. Develop cloud-specific modules and offer a consistent input/output interface, enabling teams to reuse the same patterns.
2. Standardize the CI/CD pipeline on the same lifecycle and a common remote backend for state/locking across all environments.

# You need to search across all workspaces in your HCP Terraform organization to identify which workspaces manage the AWS S3 bucket named production-data-lake. Which HCP Terraform feature provides this search capability?
The Explorer feature in HCP Terraform allows users to search across all workspaces in the organization. It provides a centralized view of all workspaces and their resources, making it easy to identify which workspaces manage specific resources, such as the AWS S3 bucket named production-data-lake.

You can search for specific resources by name, type, provider, or attributes to discover which workspaces manage particular infrastructure components. This is invaluable for understanding resource dependencies, identifying ownership, and planning changes across multiple workspaces. Explorer helps answer questions like "where is this resource managed?" or "which workspaces use this module?" without manually checking each workspace's state file.


# Describe how to organize and use HCP Terraform workspaces and projects
When using HCP Terraform, "creating a pull request on the branch of the workspace's linked repository will indeed automatically trigger a speculative plan on the workspace." This allows for changes to be previewed and evaluated before merging them into the main branch, ensuring smooth and controlled deployment processes.

In the UI and VCS workflow, every workspace is associated with a specific branch of a VCS repo of Terraform configurations. HCP Terraform registers webhooks with your VCS provider when you create a workspace, then automatically queues a Terraform run whenever new commits are merged to that branch of workspace's linked repository.

> HCP Terraform also performs a speculative plan when a pull request is opened against that branch. HCP Terraform posts a link to the plan in the pull request and re-runs the plan if the pull request is updated.

The Terraform code for a normal run always comes from version control and is always associated with a specific commit.


# In your Terraform configuration, you have created a terraform.tfvars file that sets the value of a variable named region to us-central1. You also have a default value on the variable block, setting it to us-east1. Which value takes effect?

Correct answer
us-central1

The value set in the terraform.tfvars file takes precedence over the default value defined in the variable block.

Variable precedence is: 
> CLI -var/-var-file → .auto.tfvars/other var files → terraform.tfvars → TF_VAR_ environment variables → default in the variable block. 
So in this scenario, terraform.tfvars overrides the default.

# You need to use a public Azure virtual network module from the Terraform registry, keep it on a 5.x release, and pass name and address_space inputs from variables. Which module block meets all requirements?

Your answer is correct
module "vnet" {
  source        = "Azure/network/azurerm"
  version       = "~> 5.0"
  name          = var.name
  address_space = var.address_space
}

Inputs should be expressions, not quoted strings. Local paths and raw VCS URLs do not use registry-style versioning in the module block.

# You are configuring remote state and must keep backend credentials out of both the .terraform directory and any saved plan files. Which method will meet this requirement?

Supplying the credentials using environment variables on the machine executing plan/apply is a secure way to keep backend credentials out of the .terraform directory and saved plan files. 
Environment variables are not stored in the project directory and are only accessible during the execution of the Terraform commands.


# You have developed a module named web that creates a public DNS record for a load balancer. You want to provide an output in the CLI so that you can simply click the URL and access the application after running terraform apply. What code snippets would satisfy these requirements? 
1. Your selection is correct
Add this to the root module in the outputs.tf file:

output "website_url" {
  value = "https://${module.web.public_dns}:8080/index.html"
}
Explanation
This code snippet correctly defines an output named website_url in the root module's outputs.tf file, which uses the public_dns output from the web module to construct a URL for accessing the application.

2. Your selection is correct
Add this to the /modules/web/outputs.tf file:

output "public_dns" {
  description = "DNS name of the web load balancer"
  value       = aws_lb.web.dns_name
}

Explanation
This code snippet correctly defines an output named public_dns in the /modules/web/outputs.tf file, providing the DNS name of the web load balancer created by the module.

* Use modules in configuration

Child modules expose values with output blocks defined inside the child module. 
Parent modules read those values with module.<name>.<output_name>. 
Outputs are not declared inside a module block, there is no outputs namespace on module references, and unqualified symbols like public_dns in the root module are not in scope.

# Which statements describe the key benefits that Terraform providers offer to users?
1. Enable one workflow to manage resources across many platforms by plugging in different providers
2. Abstract the target platform’s API behind a consistent resource/data-source schema and lifecycle
3. Extend Terraform via a plugin model so new services/features can ship without changing Terraform Core

> Managing storage, encryption, and locking of Terraform state files across remote backends and workspaces is NOT a key benefit provided by Terraform providers.


# What variable type is represented by a pair of curly braces {} containing a series of key/value pairs?
Your answer is correct
maps and objects

Explanation
Curly braces containing key-value pairs represent maps and objects in Terraform. Maps are used to store a collection of key-value pairs, while objects are used to define complex data structures with nested attributes. This variable type is commonly used for defining configurations and resources in Terraform.


1. Numbers and booleans are simple data types in Terraform. 
   Numbers are used to represent numerical values, while booleans are used to represent true or false values.
2. Strings are represented by double quotes, while sets are represented by curly braces with individual values separated by commas.
3. Lists and tuples are represented by square brackets in Terraform.
   Lists are used to store ordered collections of values, while tuples are used to store fixed-size collections of values.

# You have a resource in your public cloud that was deployed manually, but you want to reference its attributes throughout your configuration without hardcoding values. How can you achieve this?
Adding a data block to your configuration allows you to query the existing resource and access its exported attributes. By using these attributes throughout your configuration, you can dynamically reference different values without hardcoding them, providing flexibility and maintainability.

Any time you need to reference a resource that is NOT part of your Terraform configuration, you need to query that resource using a data block - assuming a data source is available for that resource type. Once you add the data block to your configuration, you will be able to export attributes from that data block using interpolation like any other resource in Terraform. For example, if you had an AWS S3 bucket, you could get information using a data block that looked like this:


data "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-lookup-bucket-btk"
}
Once you add the data block, you can refer to exported attributes like this: data.aws_s3_bucket.data_bucket.arn

# Generate and review an execution plan for Terraform

When you run terraform plan, Terraform compares your configuration (desired state) with the actual current state of infrastructure by querying the provider APIs. The manual change made in the AWS console created drift—the real infrastructure no longer matches what's defined in your Terraform configuration. The plan will show that Terraform needs to update the security group to remove the manually added rule and restore it to match your configuration. This is a key feature of Terraform: it continuously reconciles actual infrastructure with your desired configuration, detecting and reporting drift. Terraform will propose changes to bring the infrastructure back in line with your code, regardless of how the drift occurred.


# You have recently run terraform apply successfully using the local backend. You notice Terraform has created a new file called terraform.tfstate.backup in your working directory. What is the purpose of this file?

It contains the previous state before the most recent apply, allowing manual recovery if the current state becomes corrupted.

If your current terraform.tfstate becomes corrupted or you need to recover from a mistake, you can manually rename this backup file to terraform.tfstate. However, this is a manual process - Terraform doesn't automatically use the backup for rollback. The backup contains only one previous version (not the full history), and it's in the same JSON plaintext format as the main state file, not encrypted or compressed.

# local backend in Terraform 
The local backend stores state on the operator’s filesystem (terraform.tfstate by default). 
It’s simple and suitable for single-user or test workflows, but it doesn’t provide remote sharing, server-side locking, or automatic encryption. Teams typically adopt a remote backend to gain these capabilities.

The local backend in Terraform writes the state to a file named terraform.tfstate in the current working directory by default. This file contains the current state of the infrastructure and any changes made during Terraform operations.

# Manage resource drift and Terraform state
Terraform automatically queries the real infrastructure to refresh state data before generating the plan, but doesn't save the refreshed state to the file

During a standard terraform plan, Terraform automatically queries your infrastructure providers to refresh the state data in memory. This ensures the plan compares your configuration against the current real-world state. 
However, this refreshed state is only held in memory and is not written to the state file - the state file is only updated during terraform apply. 
If you want to update the state file with current infrastructure values without making configuration changes, you need to use terraform apply -refresh-only. The -refresh flag defaults to true, so you don't need to specify it explicitly for normal operations.

# You have a workspace that deploys a VPC and subnets, and another workspace that deploys applications into that VPC. You want the application workspace to automatically run a plan whenever the networking workspace completes a successful apply. What HCP Terraform feature should you configure?

Using "run triggers" is the correct choice in this scenario as it allows you to connect the networking workspace to the application workspace. By setting up run triggers, you can automatically trigger a plan in the application workspace whenever the networking workspace successfully applies changes. This ensures seamless coordination between the two workspaces.

Run triggers in HCP Terraform create automatic dependencies between workspaces. 
When you configure a run trigger, HCP Terraform will automatically queue a plan in the target workspace whenever a successful apply completes in the source workspace. 
This is ideal for scenarios where infrastructure has dependencies, such as networking infrastructure that must be in place before applications are deployed. Run triggers ensure that dependent infrastructure stays synchronized without manual intervention.

# By default, where does Terraform download and store modules referenced in a configuration?

> in the .terraform/modules subdirectory in the current working directory
> The .terraform directory contains the modules and plugins used to provision your infrastructure.

The modules are downloaded into a .terraform subdirectory of the current working directory. 
> Don't commit this directory to your version control repository.


# You have decided to move your state file to an Amazon S3 remote backend. You configure Terraform as shown below. What command should be run in order to complete the state migration while copying the existing state to the new backend?

terraform {
  backend "s3" {
    bucket = "tf-state-bucket"
    key    = "terraform/krausen/"
    region = "ap-south-1"
  }
}
Your answer is correct
> terraform init -migrate-state
Running terraform init -migrate-state command is the correct choice to complete the state migration while copying the existing state to the new backend. This command initializes the backend configuration and migrates the state to the specified S3 backend.

Whenever a configuration's backend changes, you must run terraform init again to validate and configure the backend before you can perform any plans, applies, or state operations. Re-running init with an already-initialized backend will update the working directory to use the new backend settings. Either -reconfigure or -migrate-state must be supplied to update the backend configuration.

When changing backends, Terraform provides the option to migrate your state to the new backend. This lets you adopt backends without losing any existing state.

> "terraform plan -refresh=false" command is used to generate an execution plan without refreshing the state. 

> terraform apply -refresh-only command is used to apply changes to the infrastructure with only refreshing the state


# You're applying changes to your production Azure infrastructure. When you run terraform apply, the creation of an Azure Virtual Machine succeeds, but the subsequent creation of an Azure Network Security Group fails due to a quota limit. What is the state of your infrastructure and state file after this failure?
The VM exists in Azure and is recorded in state, but the NSG does not exist. You can run apply again to create the NSG.


# One of your team members manually deleted an EC2 instance through the AWS console that Terraform was managing. What happens when you run terraform plan?
Terraform detects the missing instance and shows that it will recreate the resource.

Terraform detects drift when real infrastructure differs from what's recorded in state. During terraform plan, it compares the actual infrastructure with the state file and configuration. When a managed resource is deleted outside of Terraform, it detects this drift and plans to recreate the resource to match the desired configuration.

# You need to deploy resources across two different Azure subscriptions in the same Terraform configuration. How do you configure Terraform to handle this?
Defining multiple provider blocks with different alias attributes allows you to configure Terraform to handle resources across different Azure subscriptions within the same configuration. By using aliases, you can differentiate between the providers and reference them accordingly in the resources you want to deploy.

> Provider aliases allow you to define multiple configurations for the same provider. 
You can create multiple provider blocks with different alias attributes, then reference specific providers in resources using the provider argument. 
This enables the management of resources across multiple accounts, regions, or with different authentication credentials in a single configuration.

# Which advantage does HCP Terraform offer to address team collaboration challenges?
HCP Terraform offers automatic state locking, centralized state storage, state versioning, and audit logs for compliance, which are crucial for team collaboration. These features ensure that multiple team members can work on the same infrastructure code without conflicts, track changes made to the state, and maintain a history of state versions for accountability and compliance purposes.

# A team needs identical environments across regions that have a history of version control. What practice solves this most directly?
This practice directly addresses the need for consistent environments with a history in version control.
Using Infrastructure as Code (IaC) allows the team to declare the desired state of their environments in version-controlled configuration files. 

# Your AWS provider configuration is shown in the exhibit below. When running a terraform plan, the variable value is set to us-west-2, but the AWS_REGION environment variable is set to eu-west-1. Which region will the provider use?



provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Project = "Project-502"
    }
  }
}  
Correct answer
us-west-2 from the Terraform variable
The explicit region setting in the provider block (us-west-2) takes precedence over AWS_REGION, so the provider uses us-west-2.
The provider configuration in Terraform takes precedence over the environment variables. 

# You add a check block to continuously monitor that your AWS EC2 instances are using encrypted EBS volumes. During terraform plan, the check fails. What happens?
"check blocks" provide continuous validation of your infrastructure but do not block Terraform operations. When a check fails, Terraform reports it as a warning in the output, but the plan or apply continues. This allows you to monitor compliance and drift without preventing infrastructure changes. Checks are different from preconditions or postconditions, which will cause Terraform to error and halt execution when they fail.