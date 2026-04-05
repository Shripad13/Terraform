

# What does the version constraint ~> 3.0.0 mean in a provider requirement?
The version constraint ~> 3.0.0 means that only patch releases within version 3.0.x are allowed, such as 3.0.1, but not version 3.1.0. This constraint allows for updates and bug fixes within the same major version.
The ~> operator allows only the rightmost version component to increment. 
So ~> 3.0 allows versions >= 3.0.0 but < 3.1.0 (only patch updates). 
This constraint is useful when you want to automatically get bug fixes but avoid potentially breaking minor version updates.

# You have developed several new modules to share with the team and need to validate them. You also want to validate the root module. What steps should you take? (select two)
> run the "terraform test" command to validate the modules
Running the terraform test command is the correct approach to validate the modules and the root module. This command executes the tests defined in the .tftest.hcl files and ensures that the modules function as expected.

> add ".tftest.hcl files" with run and assert blocks to each module
Adding .tftest.hcl files with run and assert blocks to each module allows you to define the tests and assertions that need to be validated for each module. This step is essential for ensuring the correctness of the modules before sharing them with the team.

"terraform test" scans the module directory for native verification files and runs their run blocks, which can perform plan or apply in an isolated context and evaluate assert blocks. It reports pass or fail without changing your real infrastructure.

# What is the recommended approach for letting teams across your organization securely consume a shared Terraform state?
> configure a remote backend that supports locking and access control.

A remote backend centralizes the state so every run reads and writes the same file, usually with server-side locking, versioning, and permissions. This prevents concurrent edits, avoids drift, and enables reliable collaboration. 
Storing state in a VCS is an anti-pattern, secrets managers are not state stores, and passing local files around leads to conflicts and data loss.


# Your organization uses infrastructure across AWS, Azure, and on-premises VMware environments. The team is evaluating whether to use Terraform or separate cloud-native tools for each platform. Which statements accurately describe how Terraform handles multi-cloud and hybrid cloud workflows? 

> Terraform does NOT requires separate state files for each cloud provider to prevent conflicts between different infrastructure platforms.
> Terraform configurations are written in HCL or JSON, which is not provider-specific. This allows users to define infrastructure using a consistent syntax, regardless of the cloud provider being used.
> Terraform's provider ecosystem allows it to manage resources beyond traditional cloud services, including SaaS platforms and network devices.
> Terraform uses a consistent workflow and syntax across different cloud providers, reducing the learning curve for managing multi-cloud infrastructure.
> A single Terraform configuration can define resources across multiple cloud providers and on-premises infrastructure simultaneously.
> In Terraform, multi-cloud deployments can be managed with a single terraform apply command that applies changes across all configured providers. There is NO need to run separate apply commands for each cloud provider in the configuration.


# Your organization manages dozens of HCP Terraform workspaces used by different teams. You have been asked to simplify the structure, improve access controls, and group related infrastructure by function. How can you organize these workspaces?
Placing each team-related workspace into a team project is a logical and efficient way to organize workspaces. 
It helps to group related infrastructure by function, making it easier to understand the structure and apply access controls more cleanly. This approach allows teams to have ownership over their workspaces while still maintaining a clear organizational structure.

HCP Terraform defines a project as a folder that contains one or more workspaces, and each workspace must belong to exactly one project. This is used to organize and manage related workspaces within an organization.

# Your team uses the AWS provider that is pinned to version = "6.0.0". The AWS provider is installed from the public Terraform Registry. A critical security patch is released in version 6.0.3. You update the version constraint to version = "~> 6.0.0" and run terraform init. Why does Terraform still continue to use version 6.0.0?

Your answer is correct
Explanation
The dependency lock file ensures that the same versions of providers are consistently used across environments. When the version constraint is updated to ~> 6.0.0, Terraform respects the lock file and continues to use version 6.0.0 unless the -upgrade flag is explicitly used during terraform init.


# You have a random_pet resource that generates a name, and you want to use that name as part of a null_resource ID. Which resource block correctly references the generated pet name from the random_pet resource named app_name?
Your answer is correct
resource "null_resource" "example" { 
  triggers = { 
    name = random_pet.app_name.id 
    } 
}

The correct syntax for referencing resource attributes is resource_type.resource_name.attribute_name. 
In this example, random_pet.app_name.id references the id attribute of the random_pet resource named app_name. This creates an implicit dependency, ensuring Terraform creates the random_pet resource before the null_resource that depends on it.

# You are managing multiple resources using Terraform. You want to destroy all the resources except for a single web server, which should remain running but no longer be managed by Terraform. How can you accomplish this?

Add a "removed" block with "from = <address>" to stop managing the web server, then run "terraform apply" followed by "terraform destroy"

The "removed" block allows you to gracefully stop managing a resource without destroying it.
By adding removed with the from argument pointing to the resource address, Terraform removes it from state during the next apply while leaving the actual infrastructure intact. After running "terraform apply" to remove it from management, you can then run "terraform destroy" to delete all remaining managed resources, preserving the web server.

# How to use a specific version of the AWS provider?
Your answer is correct
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.20.0"
    }
  }
}

# In HCP Terraform, what does it mean to run Terraform as a remote operation?
Terraform runs managed by HCP Terraform are called remote operations. 
Remote runs can be initiated via webhooks from your VCS provider, UI controls in HCP Terraform, API calls, or the Terraform CLI. When using the Terraform CLI to perform remote operations, the run's progress is streamed to the user's terminal, providing an experience equivalent to local operations.

# Your team is developing Terraform configurations that require database passwords and API tokens. A developer suggests marking these values as sensitive in variable blocks to prevent them from being stored in state files. What is the behavior of the sensitive argument on variables and outputs in Terraform?
The sensitive argument redacts values from CLI output and the HCP Terraform UI, but still stores them in state and plan files.

If you need to prevent values from being stored in state entirely, you should use ephemeral values through the ephemeral argument on variables, ephemeral blocks, or write-only arguments on managed resources.

# In HCP Terraform, enabling workspace health checks provides which benefits for your infrastructure?
1. Sentinel policies are used for policy as code enforcement.
2. Continuously validating that resources continue to meet the required conditions you've defined.
3. Detecting drift by checking whether real infrastructure still matches what Terraform expects.
4. Workspace health checks in HCP Terraform do not automatically roll back out-of-compliance resources to the last known good state.

#  command correctly sets a Terraform input variable named user to the value dbadmin01 using an environment variable?
> export TF_VAR_user=dbadmin01

Terraform automatically reads environment variables that use the "TF_VAR_" prefix followed by the variable name.


# You're creating a GCP configuration that requires creating a storage bucket first, then creating an IAM binding that grants access to it. The problem is that the IAM binding doesn't directly reference the bucket resource, so it's being created too quickly. How do you ensure the bucket is created before the IAM binding is applied?
> add a depends_on = [google_storage_bucket.data] to the IAM binding resource block

# You have declared the variable as shown below. How should you reference this variable throughout your configuration?



variable "aws_region" {
  type        = string
  description = "region used to deploy workloads"
  default     = "us-east-1"
  
  validation {
    condition     = can(regex("^us-", var.aws_region))
    error_message = "The value must be a region in the USA, starting with \"us-\"."
  }
}


Your answer is correct
> var.aws_region
> by using the syntax var.variable_name

# Use variables and outputs

Input variables (commonly referenced as just 'variables') are often declared in a separate file called variables.tf, although this is not required. Most people will consolidate variable declarations in this file for better organization and management simplification. Each variable used in a Terraform configuration must be declared before it can be used. Variables are declared in a variable block - one block for each variable. The variable block contains the variable name, most importantly, and then often includes additional information such as the type, a description, a default value, and other options.

* The value of a Terraform variable can be set multiple ways, including setting a default value, interactively passing a value when executing a terraform plan and apply, using an environment variable, or setting the value in a .tfvars file. Each of these different options follows a strict order of precedence that Terraform uses to set the value of a variable.

A huge benefit of using Terraform is the ability to reference other resources throughout your configuration for other functions. These might include getting certain values needed to create other resources, creating an output to export a specific value, or using data retrieved from a data block. Most of these use dot-separated paths for elements of object values.

The following represents the kinds of named values available in Terraform:

    * <RESOURCE TYPE>.<NAME> represents a managed resource of the given type and name.

    * var.<NAME> is the value of the input variable of the given name.

    * local.<NAME> is the value of the local value of the given name.

    * module.<MODULE NAME> is a value representing the results of a module block.

    * data.<DATA TYPE>.<NAME> is an object representing a data resource of a given type and name

    * Additional named values include ones for filesystem and workspace info and block-local values
  


# Explain how Terraform uses and manages state

State is a fundamental requirement for Terraform—there's no way around it. You can store the state locally or configure a remote backend to keep it elsewhere. But overall, state is always necessary for managing resources with Terraform.

# You have a Terraform configuration that includes a Virtual Network, a subnet within that Virtual Network, and a Virtual Machine operating on that subnet. You run terraform plan for the first deployment. How does Terraform determine the order in which these resources will be created?
1. Terraform analyzes resource references to build a dependency graph automatically.
2. Terraform detects that the subnet references the Virtual Network's ID, establishing an implicit dependency
   
Terraform detects this implicit dependency and creates the Virtual Network first. Similarly, when the Virtual Machine references the subnet, Terraform understands the entire chain: Virtual Network → Subnet → Virtual Machine. This dependency graph ensures resources are created in the correct order without you needing to specify the order explicitly.

# Your organization's Terraform configuration requires AWS access keys to provision infrastructure. The team is concerned about security best practices for managing these credentials. Which approach follows Terraform best practices for managing sensitive credentials like cloud provider access keys?
Store credentials in an external secrets manager such as HashiCorp Vault and reference them in Terraform using data sources.
 you can securely retrieve the necessary information at runtime without exposing them in plain text in your configuration files.


# Understand best practices for managing sensitive data, including secrets management with Vault

 * Storing sensitive credentials in an external secrets manager like HashiCorp Vault follows Terraform security best practices because:

 * State file protection: Terraform stores all resource data in state files as plaintext, including any credentials passed as variables. External secrets managers prevent credentials from being written to state.

 * Separation of concerns: Credentials are managed independently from infrastructure code, with dedicated access controls and audit logging.

 * Dynamic credentials: Secrets managers can provide short-lived, dynamically generated credentials that automatically rotate.

 * No version control exposure: Credentials never appear in Terraform configuration files or version control history.

# You have a Terraform configuration with variable validation blocks, preconditions in resources, postconditions in resources, and check blocks. Which statements are true about how Terraform evaluates these validation mechanisms? 

1. preconditions and postconditions cause Terraform to halt execution with an error if they fail
2. variable validation blocks are evaluated during terraform validate and terraform plan


# You have an existing Google Cloud Compute Engine instance with ID my-instance that was created manually. Now, you want to manage this resource using Terraform.

How can you import the existing instance into your Terraform state using the command line?

Your answer is correct
> terraform import google_compute_instance.my_instance my-instance

 It adds the resource to Terraform's state file without modifying the infrastructure itself. After the import, you need to manually update your configuration (.tf file) to match the resource's actual settings, ensuring that future terraform apply runs work correctly.


 # In Terraform, how are input variables scoped with respect to modules?
 variables defined in a module are only accessible within that module unless explicitly passed to child modules. Child modules cannot automatically access parent values without being passed to them.
  Parents pass values to children in the module block, and children return values only via outputs.

# Which of the following are tasks that terraform apply can perform? 
1. update or replace resources to match changes made in the configuration.
2. create resources that do not yet exist
   
3. delete resources that are no longer declared in the configuration.
✅ When it does delete resources

Terraform removes resources if:

1. They exist in the Terraform state
2. But are no longer present in your configuration files

In this case, Terraform plans a destroy action to reconcile the real infrastructure with the desired state defined in your code.

⚠️ Important nuance
Terraform doesn’t blindly delete everything not in your config. It only manages:
Resources tracked in the Terraform state file
So:
If a resource exists in your cloud provider but was never managed by Terraform, it will not be touched.
If you manually remove a resource from the config but still keep it in state (e.g., via state manipulation), behavior may differ.


# A child module creates a new subnet. Which Terraform block should you define in the child so the root module can read the subnet ID?

Correct answer
> output block
 This block type in Terraform allows you to define values that can be passed back to the parent module. In this case, the subnet ID created by the child module can be defined as an output value and accessed by the root module for further use.

* The data block is used to define data sources in Terraform, such as information retrieved from external sources like APIs or databases. It is not used to pass values between modules, so it is not the correct choice for passing the subnet ID back to the root module.
  
#  Use modules in configuration

Expose values from a child with an output in the child, then read it in the parent as "module.<child>.subnet_id".
Example:

* Child (modules/network/outputs.tf)

output "subnet_id" {
  value = aws_subnet.main.id
}

* Parent

module "network" { 
  source = "./modules/network" 
}
 
output "created_subnet_id" { 
  value = module.network.subnet_id 
}


# You need to import an existing Azure resource group named production-rg into your Terraform configuration. You already created a corresponding resource block in your configuration file.
Which import block configuration will allow you to import this resource?
Correct answer
'''
import {
  to = azurerm_resource_group.production
  id = "/subscriptions/.../resourceGroups/production-rg"
}
'''
Use the import block with "to" specifying the resource block in the configuration and id specifying the resource ID of the existing resource group.
 Once you define the import block and run terraform apply, Terraform will import the resource into your state file and associate it with the configuration block.


# You have decided to remove a VM from your design and need Terraform to delete it without using the terraform destroy command. What should you do next?
1. Deleting the VM's resource block from the configuration will instruct Terraform to remove the VM during the next apply operation, as the resource will no longer be managed by Terraform.
2. When a managed resource is removed from the configuration and you run terraform apply, Terraform plans to destroy it so the real infrastructure matches the desired state defined in code.

# Your AWS configuration creates multiple subnets using for_each, and you need to launch an EC2 instance in a specific subnet, as shown in the exhibit below. Which expression correctly references the private subnet's ID for your EC2 instance?
resource "aws_subnet" "app" {
  for_each = {
    public  = "10.0.5.0/24"
    private = "10.0.0.0/24"
    data    = "10.0.2.0/24"
  }
  
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
}

Your answer is correct
> aws_subnet.app["private"].id
 When resources are created with for_each using a map, you access specific instances using bracket notation with the map key as a string.
 By using the key private within square brackets, you are accessing the specific private subnet defined in the for_each block.
 
 Note: This is different from count, which uses numeric indexes - for_each uses the actual keys from your map, making references more readable and maintainable.

# Your Terraform configuration creates a VMware virtual machine. You want to ensure that the VM is created with at least 4 GB of memory, and if someone tries to create it with less, Terraform should fail before attempting creation. Which approach is correct? 
1. Your selection is correct
Add a "lifecycle block" with a "precondition" to the resource, such as:

lifecycle {
  precondition {
    condition     = var.memory >= 4096
    error_message = "Memory must be at least 4096 MB."
  }
}
Adding a lifecycle block with a precondition to the resource ensures that Terraform checks the condition before attempting to create the VMware virtual machine.

2. Your selection is correct
Add a "validation block" to the "variable", such as:

validation {
  condition     = var.memory >= 4096
  error_message = "Memory must be at least 4096 MB."
}
Adding a validation block to the variable allows you to enforce constraints on the values that can be assigned to the variable.

1. Why Adding a check block to the configuration will NOT work here?
check "memory_check" {
  assert {
    condition     = var.memory >= 4096
    error_message = "Memory must be at least 4096 MB."
  }
}
The check block is used for defining custom validation rules for configurations.


# You have enabled Terraform logging and are reviewing the output. What type of information will verbose Terraform logs typically include that the standard output does not show?
1. internal state file operations including reads, writes, and lock acquisitions
2. provider API requests and responses showing the exact data sent to and received from cloud providers
3. plugin communications between Terraform core and provider plugins
   This level of detail helps you understand exactly what Terraform is doing behind the scenes, which is essential for troubleshooting complex issues.


# Your organization is using HCP Terraform with separate workspaces for networking and application infrastructure. You want the app-tier workspace to automatically start a new run whenever networking-vpc finishes a successful apply so downstream changes stay in sync.

Which HCP Terraform feature should you configure?
 
> run triggers between the two workspaces.
> HCP Terraform lets you link workspaces using "run triggers" between workspace. 

# You're building a Google Cloud Platform infrastructure and write the following configuration shown in the exhibit below. What will happen when you run terraform apply?

data "google_compute_network" "shared" {
  name = "bk-company-network"
}
 
resource "google_compute_subnetwork" "app" {
  name          = "bk-app-subnet"
  ip_cidr_range = "10.5.2.0/24"
  network       = data.google_compute_network.shared.id
  region        = "us-central1"
}

Your answer is correct
> Terraform will create the subnet in the existing shared network without modifying the network itself.

# Install and version Terraform providers

Every resource type is implemented by a provider; without providers, Terraform can't manage any kind of infrastructure.

Most providers configure a specific infrastructure platform (either cloud or self-hosted). Providers can also offer local utilities for tasks like generating random numbers for unique resource names.

* Each platform you create resources on in Terraform requires a **different** provider or plugin. This is because each platform has its own unique API and set of resources that need to be managed, requiring specific providers to interact with them effectively.


# You moved an existing EC2 instance from aws_instance.web to module.servers.aws_instance.web as part of a refactoring project. Now terraform plan wants to destroy and recreate it.

Which block should you add to prevent Terraform from recreating the resource?
Your answer is correct
> moved block

Explanation
The moved block in Terraform is used to inform Terraform about changes in resource names or locations within your configuration. When you rename or move resources, the moved block helps Terraform understand that the resource was moved rather than recreated, allowing it to update the state file accordingly without destroying and recreating the resource.'



# Your child module creates an Azure storage account and defines this output as shown in the exhibit below.

output "storage_account_name" {
  value = azurerm_storage_account.data.name
}
In your root module, you call this module as shown below:


module "storage" { 
  source = "./modules/storage" 
}
How do you correctly reference the storage account name in your root module?

Your answer is correct
> module.storage.storage_account_name
This syntax directly accesses the output value named storage_account_name from the storage module.


# A coworker gave you a Terraform configuration file containing the code snippet below. Where will Terraform download the referenced provider from?
'''
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}
 
provider "kubernetes" {}
'''
Your answer is correct
> the official Terraform public registry


# Which of the following are collection or structural types that can be used when declaring a variable in order to group values together?
> Your answer is correct - Tuple, Object, List, Map

Strings, numbers, and bools are sometimes called primitive types. 
Lists/tuples and maps/objects are sometimes called complex types, structural types, or collection types.

* string: a sequence of Unicode characters representing some text, like "hello".

* number: a numeric value. The number type can represent both whole numbers like 15 and fractional values like 6.283185.

* bool: a boolean value, either true or false. bool values can be used in conditional logic.

* list (or tuple): a sequence of values, like ["us-west-1a", "us-west-1c"]. Identify elements in a list with consecutive whole numbers, starting with zero.

* set: a collection of unique values that do not have any secondary identifiers or ordering.

* map (or object): a group of values identified by named labels, like {name = "Mabel", age = 52}.


# A team member ran terraform apply and the operation was interrupted (their laptop crashed), and the state lock wasn't released. Other team members can't run Terraform commands because they get a "state is locked" error. What command should be used to resolve this situation?

Your answer is correct
> use the command **terraform force-unlock <lock-id>** to manually release the stuck lock

# Which of the following statements are true regarding the Terraform state file?
1. it may contain sensitive data that you might not want others to view
2. remote state is recommended when more than one person wants to manage the infrastructure managed by Terraform
3. the state file is formatted using JSON
4. by default, state is stored in a file named terraform.tfstate in the current working directory
5. the state file DOES NOT stores a complete history of all changes made to your infrastructure over time
   **State file only stores current state of infra.**

# Your team uses a VCS-driven workflow in HCP Terraform. When a pull request is opened that includes Terraform changes, what happens automatically in HCP Terraform?
HCP Terraform automatically runs a speculative plan to preview the changes that would be made if the pull request is merged. The results of this plan are then posted as a comment on the pull request for review and validation.
 The actual apply only happens after the pull request is merged, and only if configured to do so.


# You are currently using version 4.50.0 of the azurerm provider. You need to provision a few resources that are supported with the latest provider version, so you add the resource blocks and update the required_providers block to version = 4.53.0.

What happens when you run terraform plan?
Your answer is correct
> Terraform shows an error and requires you to run the command "terraform init -upgrade"

When you update the "required_providers" block to a newer version, Terraform needs to download the updated provider version. To ensure that Terraform uses the latest provider version and provisions resources correctly, run the command "terraform init -upgrade" after updating the provider version in the configuration.

When the version constraint in "required_providers" doesn't match the locked version, Terraform detects the inconsistency and fails with an error message. It won't proceed with the plan until you run "terraform init" -upgrade to update the lock file and download a provider version that matches your new constraints. This ensures the configuration and lock file stay synchronized.


# terraform state rm command
The terraform state rm command is used to remove a resource from the Terraform state. to remove a specific resource from the state file.

# terraform show command
The terraform show command is used to provide human-readable output from a state or plan file. This can be used to inspect a plan to ensure that the planned operations are expected, or to inspect the current state as Terraform sees it.

Machine-readable output is generated by adding the -json command-line flag.


# In your Terraform configuration, you need to set a variable value based on another variable. If var.environment equals prod, you want to set the instance count to 5, otherwise set it to 2. Which expression correctly implements this logic?

Your answer is correct
> instance_count = var.environment == "prod" ? 5 : 2

Explanation
conditional expression in Terraform uses the format **condition ? true_value : false_value**


# What type of workflows are available when using HCP Terraform? 
1. VCS-driven workflow
2. API-driven workflow
3. CLI workflow

# You run terraform plan on your configuration that uses a remote backend with state locking. What happens with the state lock during this operation?
Terraform acquires a lock to prevent state modification

# Terraform locks the state file for several reasons:

1. Prevents Corruption: The primary reason is to prevent multiple processes from making changes to the state file simultaneously, which could lead to a corrupted state file and inconsistent infrastructure.

2. Ensures Accurate Planning: A terraform plan automatically performs a refresh to synchronize the Terraform state with the actual remote infrastructure before determining what changes to propose. If another operation were running concurrently and modifying the state, the plan would be based on partially or fully invalid results. This prevents a saved plan from potentially causing issues when it is eventually applied.

3. Maintains Consistency: By locking, Terraform ensures that the plan you are reviewing is based on a stable, consistent view of the infrastructure at that moment.
In fact, there's a specific flag to PREVENT plan from acquiring a lock (-lock=false)


# Which methods can Terraform use to install providers? 
1. "Terraform can install providers from a filesystem mirror in a local directory." This method allows for custom or private providers to be stored locally and used across different Terraform projects without relying on external sources.
2. Terraform can install providers from the Terraform Registry at registry.terraform.io. 
3. "Terraform can install providers from a provider mirror configured in the CLI configuration." This allows for a centralized location to manage and distribute provider installations across different Terraform projects.
   
# Below are NOT the right methods for Instaling Providers
1. Compiling from source code during terraform init is NOT a method that Terraform uses to install providers
2. Direct download from the provider developer's GitHub releases is NOT a method that Terraform typically uses to install providers.

# You need to define a variable that contains subnet configuration data, including an IP address (string) and a subnet mask (number). What type of variable should you use?
Correct answer
> type = object()
Using an object type variable allows you to define a single input variable that can hold multiple values, such as the IP address (string) and subnet mask (number). This type of variable is suitable for grouping related data together and maintaining the structure of the input data.



# You have three S3 buckets that were manually created with names app-data-dev, app-data-staging, and app-data-prod. You want to manage them in Terraform using a single resource block with for_each as shown in the exhibit below. How should you structure the import blocks to import all three buckets?

resource "aws_s3_bucket" "app_data" {
  for_each = toset(["dev", "staging", "prod"])
  bucket   = "app-data-${each.key}"
}

Correct answer
Create three separate import blocks, one for each bucket, with the to attribute pointing to aws_s3_bucket.app_data["dev"], aws_s3_bucket.app_data["staging"], and aws_s3_bucket.app_data["prod"]

Explanation
This choice correctly structures the import blocks by creating three separate import blocks, one for each bucket. Each import block specifies the target resource using the to attribute with the corresponding key value from the for_each loop.
 Terraform treats each for_each instance as a separate resource in state, so they must be imported individually.


# In HCP Terraform, what is a change request?
Change requests are about tracking planned changes
Sentinel policies focus on enforcing security rules and compliance.

Correct answer
a tracked request that lists planned changes for one or more workspaces so teams can manage a backlog of infrastructure work


# A development team is deciding between two deployment strategies: either using Terraform to provision new infrastructure for each deployment or provisioning base infrastructure once and updating it with configuration changes. Which of the following are advantages of the immutable infrastructure pattern? 
1. simplifies rollback procedures by deploying previous infrastructure versions rather than reverting changes
2. reduces the risk of inconsistent environments resulting from configuration updates over time
3. eliminates configuration drift since servers are never modified after initial provisioning

> The focus of immutable infrastructure is on provisioning new infrastructure for each deployment rather than updating existing infrastructure.


# What is the purpose of the .terraform.lock.hcl file in a Terraform project?
The .terraform.lock.hcl file is a dependency lock file. 
Keeping this file in version control ensures every machine and CI job installs the same provider builds, improving reproducibility and supply chain integrity.
The .terraform.lock.hcl file is used to lock provider versions and checksums, ensuring that consistent installs are maintained across different environments. 
This helps prevent unexpected changes or updates to providers that could potentially break the infrastructure.


# #
> When you modify the backend configuration in your terraform block, such as changing the S3 bucket name, **you need to run terraform init again**. This command initializes the backend configuration and ensures that Terraform recognizes the changes you made to the backend settings.

# You are adding a new resource block and notice it doesn't specify a provider argument. How does Terraform determine which provider configuration to use?
Correct answer
> Terraform selects the provider configuration with a matching type in the same module.

# You need to authenticate your local Terraform CLI to run plans against an HCP Terraform workspace. According to HashiCorp, what is the correct way to set up authentication?
> Run "terraform login", generate a user API token in the browser, and let Terraform store that token in ~/.terraform.d/credentials for future commands.

##

> "terraform plan -refresh-only" is used to update the state file with real-world infrastructure. It does not provide a preview of the changes, so you cannot validate them without impacting existing workloads.

> Running "terraform apply -lock=false" will instruct Terraform not to hold a state lock during the operation. This is dangerous if others might concurrently run commands against the same workspace. Using this method does not allow you to validate the changes without affecting production workloads.


# Which of the following statements best describe the differences between the required_providers block and the provider block in Terraform?
1. The required_providers block specifies version constraints, while the provider block configures settings like region and credentials
2. The required_providers block is where you declare which providers your configuration depends on and pin version constraints using operators like ~>, >=, or =. 
3. The provider block is where you supply runtime configuration such as the region to deploy to, authentication credentials, or default tags.
4. The required_providers block is nested inside the terraform {} block, while the provider block is a top-level block
5. You can define multiple configurations of the same provider using the alias argument in the provider block
6. The alias argument is used in the provider block to create alternate configurations of the same provider, such as deploying to multiple AWS regions. 
7. Resources reference the alternate configuration using the syntax provider = <name>.<alias>. The alias argument is not used in the required_providers block.

# You have the following configuration defined in a terraform.tf file as shown in the exhibit below. What are true statements when considering this code? (select three)

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.21.0"
    }
  }
}
 
provider "aws" {
  region = "ap-south-1"
}
 
provider "aws" {
  region = "ap-south-2"
}


1. Any resource blocks that do not include the provider argument will use the default provider for provisioning and managing resources.
2. Resource blocks can use the provider argument to define what specific provider configuration to use when multiple provider blocks are defined.
3. terraform plan will result in the error Duplicate provider configuration unless you add an alias argument to one of the provider blocks.


# HCP Terraform to create infrastructure
> HCP Terraform automatically stores state files remotely and provides state locking to prevent concurrent operations by multiple users from corrupting the state.

# You're creating a variable for the cloud provider region and want to ensure users only provide valid US regions. You want Terraform to reject invalid values before any resources are created. Where should you add this validation logic?

1. add a validation block inside the variable declaration

# Your team has started a new project that uses Terraform’s default local backend. Engineers on your team work from laptops, sometimes using shared or synced folders.

Which statements correctly describe the local backend and its exposure risks?
1. Weak or shared permissions can expose the state to other users on the machine.
2. Committing the state to version control can leak sensitive data to anyone with repo access.
3. The local backend writes terraform.tfstate as an unencrypted JSON file in the current working directory by default.
4. Marking outputs as sensitive in Terraform does not prevent those values from being stored in the state file. While it helps prevent accidental exposure in command-line outputs, it does not eliminate the risk of sensitive data being stored in the state file itself.

# You enabled verbose logging to troubleshoot an issue. After resolving the problem, what should you do to disable Terraform logging for subsequent operations?
> unset the TF_LOG environment variable
> By removing the environment variable, Terraform will revert to its default logging behavior and stop producing verbose logs.



# You have a Kubernetes deployment managed by Terraform. You need to replace a specific pod deployment because a critical security patch requires recreating resources, but you want to keep all other resources unchanged. Your configuration is shown in the exhibit below.

What command should you use to force the replacement of only the api deployment?


resource "kubernetes_deployment" "api" {
  metadata {
    name = "api-server"
  }
  # ...
}
 
resource "kubernetes_deployment" "worker" {
  metadata {
    name = "background-worker"  
  }
  # ...
}
 
resource "kubernetes_service" "api-svc" {
  metadata {
    name = "api-service"
  }
  # ...
}

Correct answer
> terraform apply -replace=kubernetes_deployment.api

Explanation
Using the terraform apply -replace=kubernetes_deployment.api command specifically targets the deployment named api-server and forces its replacement without affecting any other resources. This command ensures that only the specified deployment is recreated, keeping all other resources unchanged.

> . There is no built-in flag called force-replace in Terraform. 


# You are migrating from local state to HCP Terraform using the CLI-driven workflow. Which of the following steps are required to complete this migration? 
1. Run terraform init to reinitialize the working directory and copy the existing local state to the HCP Terraform workspace.
2. Add a cloud block inside the terraform block to define the HCP Terraform organization and workspace.
3. Run terraform login to generate and store a user token so the CLI can authenticate to HCP Terraform.


# You manage a Kubernetes cluster with Terraform that includes many different deployments, services, and various configmaps. Your team decides to migrate to a new cluster, and you need to completely tear down the old cluster. After running terraform destroy and confirming, what happens to the state file?
> The state file remains, but no longer contains any resources

# Which statements are correct regarding the source argument in a Terraform module block?
> The source value must be a local file, directory, or a remote source such as the public Terraform registry.


