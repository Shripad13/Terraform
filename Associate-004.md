
# Four Major Additions to TF Associate 004
1. Explicit Dependencies & lifecycle Rules -
    Updates include the depends_on and create_before_destroy lifecycle rules.
2. Custom Validation COnditions -
    Know how to validate configurations using conditions, like the validate block for input variables.
3. Ephermal values & Write Only Arguments - 
    Know how to protect sensitive data and keep it out of state using ephermal values & write-only arguments.
4. Expanded HCP Terraform Coverage-
    Now includes more HCP Terraform feature such as workspaces, projects, governance, collaboration tools & more.


# IAC means:
Terraform is written in HashiCorp Configuration Language (HCL). However, Terraform also supports a JSON-compatible syntax.

Terraform is primarily designed on immutable infrastructure principles

Terraform is also a declarative language: you simply declare the desired state, and Terraform ensures that real-world resources match that state as written. An imperative approach differs, in which the tool uses a step-by-step workflow to achieve the desired state.

Define and provision infrastructure using code for consistent, repeatable deployments.

>  Describe the Terraform workflow
The core workflow is initialize → (optionally) validate → plan → apply → destroy. 
Initialization downloads providers/modules and prepares the .terraform file. Skipping this step leads to errors when planning or applying.

# advantages of using Infrastructure as Code
> Infrastructure as Code enables users to automate a manual task for easier deployment.
> Infrastructure as Code is relatively easy to learn and write, regardless of a user's prior coding experience.
> Infrastructure as Code provides configuration consistency and standardization among deployments.
> Infrastructure as Code is easily repeatable, allowing the user to reuse code to deploy similar yet different resources.
> Infrastructure as Code gives the user the ability to recreate an application's infrastructure for disaster recovery scenarios
> IaC enables self-service for developers and operators by providing them with the ability to define and deploy infrastructure resources using code. This empowers teams to quickly spin up environments, test new features, and iterate on infrastructure changes without relying on manual processes or waiting for centralized IT teams.
> provides the ability to version control the infrastructure and application architecture
>  It allows teams to track changes, collaborate effectively, and roll back to previous states if needed.
> API-driven workflows as they allow for automation and programmability of infrastructure provisioning and management. This enables seamless integration with other tools and systems, improving efficiency and reducing manual errors in day-to-day operations.



# Terraform state
Terraform state is fundamental to how Terraform operates. The state file serves three primary purposes: First, it creates a mapping between your configuration code and real-world resources. When you define an AWS EC2 instance in your .tf file, Terraform records in state which actual EC2 instance (with its specific resource ID) corresponds to that configuration block. Without this mapping, Terraform wouldn't know which resources it manages and which were created by other means.

Second, state tracks metadata that isn't visible in your configuration, such as resource dependencies. Terraform uses this metadata to determine the correct order for creating, updating, or destroying resources; ensuring a VPC exists before creating subnets within it, for example.

Third, state improves performance by caching resource attributes. Instead of querying your cloud provider API for every attribute of every resource during each plan operation, Terraform reads this information from state, making operations significantly faster, especially in large infrastructures. Note that state does NOT handle encryption of configuration files, fix syntax errors, or validate credentials - these are separate Terraform functions handled by other mechanisms.

# Terraform module
A Terraform module is a reusable collection of resources that can be used across different Terraform configurations. While modules are a fundamental concept in Terraform for organizing and reusing code.

#  Terraform variable
A Terraform variable is a parameter that can be passed into Terraform configurations to make them more flexible and reusable. Variables allow users to customize configurations without modifying the underlying code.

# Terraform provider 
A Terraform provider is a plugin that interacts with a specific type of infrastructure, such as AWS, Azure, or Google Cloud. Providers are responsible for understanding API interactions and exposing resources for Terraform to manage, making them an essential component of Terraform configurations.

# Terraform backend 
A Terraform backend is a configuration setting that determines where state data is stored and how Terraform operations are executed. Backends define how Terraform interacts with remote storage services like AWS S3 or HashiCorp Consul, 


When Terraform runs, it loads the plugins required to manage the resources specified in the configuration files. Each provider has its own plugin, and Terraform loads the plugins for the providers specified in the configuration.

The plugin is responsible for interacting with the cloud provider's API, translating Terraform configurations into API calls, and managing the state of the resources that Terraform manages.

Plugins are stored in the Terraform plugin cache, a directory on the local machine that contains the binary executables for each plugin. When Terraform runs, it looks for plugins in the cache and automatically downloads any missing plugins from the Terraform Registry or a specified source.

Terraform plugins are written in Go and follow a specific plugin protocol, which defines the interactions between Terraform and the plugin. The plugin protocol allows Terraform to communicate with the plugin and provides a standard way for plugins to manage resources across different providers.

# Refer to resource attributes and create cross-resource references
When you reference another resource's attribute using the syntax resource_type.resource_name.attribute, Terraform both retrieves that attribute's value and automatically creates a dependency between the resources. In this case, aws_vpc.main.id tells Terraform to use the VPC's ID for the subnet's vpc_id argument and ensures the VPC must be created before attempting to create the subnet. This implicit dependency is how Terraform determines the correct order for resource creation.


# data blocks
In Terraform, data blocks are used to retrieve data from external sources, such as APIs or databases, and make that data available to your Terraform configuration. With data blocks, you can use information from external sources to drive your infrastructure-as-code, making it more dynamic and flexible.
This information can then be used to conditionally create, update, or delete resources, making your Terraform configurations more flexible and adaptable to changing requirements.

# In Terraform, how can a dependency on a provider be established?
Terraform relies on plugins called "providers" to interact with remote systems. Terraform configurations must declare which providers they require, so that Terraform can install and use them.

1. Declaring a provider block in the configuration with version constraints is essential to establish a dependency on a specific provider. This ensures that the configuration uses the correct provider version to manage resources.
2. Using a resource or data block that belongs to a specific provider in the configuration creates a direct dependency on that provider. This indicates that the resources being managed in the configuration require the functionality provided by that specific provider.
3. Having existing resource instances for a provider recorded in the current state establishes a dependency on that provider. Terraform uses the state file to track the resources managed by each provider, ensuring that the configuration is consistent with the existing infrastructure.

# is it necessary to specify a version argument in the module block?
The version argument in the module block is optional,
 but it is highly recommended to specify a version to ensure consistent and reproducible deployments. Without a version specified, Terraform defaults to the latest version of the module, which may lead to unexpected changes in your infrastructure.

# Terraform configuration using multiple providers
An alias meta-argument is used when using the same provider with different configurations for different resources. This feature allows you to include multiple provider blocks that refer to different configurations. In this example, you would need something like this:



provider "aws" {
  region  = "us-east-1"
}
 
provider "aws" {
  region = "ap-south-1"
  alias  = "mumbai"
}
When writing Terraform code to deploy resources, the resources that you want to deploy to the mumbai region would need to specify the alias within the resource block. This instructs Terraform to use the configuration specified in that provider block. So in this case, the resource would be deployed to ap-south-1 region and not the us-east-1 region. This configuration is common when using multiple cloud regions or authentication methods.

# Define resource dependencies in configuration
Implicit dependencies allow Terraform to automatically determine the correct order for creating, updating, or deleting resources, ensuring that resources are created in the right order and that dependencies are satisfied.

# HCP Terraform 
When using local execution in HCP Terraform, the platform only handles storing and syncing the workspace's state file. This means that you need to run the plan and apply commands locally on your own machine, while HCP Terraform takes care of managing the state file.

Many of HCP Terraform's features rely on remote execution and are not available when using local operations. This includes features like Sentinel policy enforcement, cost estimation, and notifications.

You can disable remote operations for any workspace by changing its Execution Mode to Local. This causes the workspace to act only as a remote backend for Terraform state, with all execution occurring on your own workstations or continuous integration workers.

> HCP Terraform agents
HCP Terraform agents are lightweight programs deployed within your target infrastructure environment. Their primary function is to receive Terraform plans from HCP Terraform, execute those plans locally, and apply the desired infrastructure changes. This allows you to manage private or on-premises infrastructure with HCP Terraform without opening your network to public ingress traffic.

# terraform init -reconfigure
Using the -reconfigure flag with the terraform init command allows you to reconfigure the backend without copying the existing state. This is the correct flag to use when changing the backend configuration without transferring the existing state data.


#  the following actions are performed during a terraform init
1. downloads the providers/plugins required to execute the configuration
2. downloads the required modules referenced in the configuration
3. initializes the backend configuration


# Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows

Using a single tool like Terraform across multiple clouds provides a unified, declarative workflow (init/plan/apply), one language (HCL), and reusable modules. This means teams don’t have to learn and maintain different CLIs, SDKs, or approval patterns for each provider. Such consistency reduces mental effort and errors, makes CI/CD, policy enforcement, reviews, and audit logging consistent, and accelerates onboarding. It also promotes shared libraries and testing practices that work everywhere, enhancing reliability. While you still account for provider-specific details, you manage them behind a common interface, gaining portability and scale without a collection of one-off tools.

# TF_VAR_
The prefix string TF_VAR_ is necessary when assigning a value to a Terraform input variable through an environment variable. This prefix indicates that the environment variable is intended to set a Terraform variable.
To use a variable in Terraform, you need to define the variable using the following syntax in your Terraform configuration:



variable "instructor_name" {
  type = string
}
You can then set the value of the environment variable when you run Terraform by exporting the variable in your shell before running any Terraform commands:

$ export TF_VAR_instructor_name="bryan"
$ terraform apply   

# In HCP Terraform, what is the purpose of using a run trigger?
Using a run trigger in HCP Terraform allows for the automation of queuing a new run in one workspace after another workspace applies successfully. This helps in orchestrating the workflow and dependencies between different workspaces, ensuring that changes are applied in the correct order.

Run triggers connect workspaces so that when a “source” workspace completes a successful apply, HCP Terraform automatically queues a run in the “downstream” workspace. This is commonly used to keep dependent stacks in sync.


# Validate configuration using custom conditions

The validation block with condition = var.instance_count == 2 enforces that only the value 2 is accepted, and emits a clear error message otherwise. This leverages Terraform’s input variable validation for uniquely restrictive requirements.


variable "instance_count" {
  type = number
 
  validation {
    condition     = var.instance_count == 2
    error_message = "You must request two web instances."
  }
}

# Terraform data source
Data sources enable fetching or computing data for use elsewhere in a Terraform configuration. The use of data sources enables a Terraform configuration to leverage information defined outside of Terraform or by another separate Terraform configuration.

A Terraform data source is a read-only construct that allows querying provider APIs to retrieve specific attributes or information that can be used in other parts of the configuration. It helps in integrating external data into Terraform configurations without actually creating or managing any infrastructure resources.

# Why should users not commit the terraform.tfstate file to version control? 
Version control systems (VCS) do not provide state locking, which means that concurrent runs of Terraform can lead to conflicting commits and potentially corrupt the state file. This can result in inconsistencies and errors in the infrastructure management process
Committing the terraform.tfstate file to version control can expose plaintext secrets and detailed resource data, as well as the commit history. This can pose a security risk by making sensitive information accessible to unauthorized users.

# difference is between terraform show and terraform state show
terraform show is useful when you want a complete overview of all managed infrastructure
It provides detailed information about resources, their attributes, and their dependencies, 
terraform show displays the entire state file without requiring any additional arguments
When using terraform state show, you need to specify a resource address to view the details of that specific resource. This command allows you to inspect the state of individual resources within the Terraform state.
ex- terraform state show aws_instance.web

> terraform output
The terraform output command is used to extract the values of output variables defined in the Terraform configuration. It is not used to list all resources tracked in the state file, so it is not the correct command for quickly viewing a complete list of resources.

# Terraform report the validation error?
Variable validation blocks are checked during the validation phase of Terraform's workflow, which occurs during commands like terraform validate and terraform plan. If the condition evaluates to false, Terraform immediately reports the custom error message and stops execution before attempting to create, modify, or destroy any resources. This early validation helps catch configuration errors before any infrastructure changes are made.

# You have a Terraform project with multiple subdirectories: /dev, /staging, and /prod. Each directory contains a separate Terraform configuration for each different environment. Before deploying resources, where do you need to run terraform init?

Each directory containing Terraform configuration files is a separate working directory and must be initialized independently. Running terraform init in one directory only initializes that specific directory - it downloads providers and modules to a .terraform subdirectory within that directory.

Even though /dev, /staging, and /prod might use the same providers, each needs its own initialization because each has its own local .terraform directory for downloaded plugins. You must navigate to each directory and run terraform init before you can plan or apply changes in that environment.

Never copy the .terraform directory between working directories; always run init in each location.

# purpose of Terraform’s dependency graph?
builds a graph of dependencies to perform create/update/destroy operations from it

# How do you specify which provider Terraform should install for a configuration?
Defining the provider in the required_providers block in the configuration file is the correct way to specify which provider Terraform should install for a configuration. This ensures that Terraform knows which provider to download and use for the resources defined in the configuration.

1. Your organization manages a Google Cloud project with 50 resources across multiple services. You need to decommission only the Cloud SQL database instance and its backup policy while keeping all other infrastructure running. What is the most appropriate approach?
> By removing the database and backup resource blocks from your configuration and then running terraform apply, you specifically target only the resources you want to decommission while keeping the rest of the infrastructure intact. This approach ensures that only the Cloud SQL database instance and its backup policy are removed, meeting the requirement to decommission those resources while preserving the others.

2.  What is the purpose of this .terraform/ directory?
The .terraform/ directory is used to store Terraform's local working data, such as installed provider and module plugins and backend metadata. This directory helps Terraform manage and track the necessary components for executing infrastructure changes.

The .terraform/ directory is Terraform’s local working cache for a given module. When you run terraform init, Terraform downloads provider binaries into .terraform/providers/, fetches modules into .terraform/modules/, and writes backend/registry metadata it needs to run. It’s not your configuration, and it shouldn’t hold credentials or your terraform.tfstate (state lives in the working directory or a remote backend). In short, .terraform/ lets Terraform operate reproducibly by pinning and caching the exact providers/modules your config requires.

3.
The state file can indeed contain sensitive values in plaintext by default, which can pose a security risk if not handled properly. It is important to be cautious about storing sensitive information in the Terraform state file.

Marking a variable as sensitive = true in Terraform does not prevent it from being written to the state file. It only ensures that the value is redacted in the CLI output and logs, but it will still be stored in the state file.

4. Which Terraform command checks modules, attribute names, and value types to ensure the configuration is syntactically valid and internally consistent?
The terraform validate command is used to check and report errors within modules, attribute names, and value types to ensure they are syntactically valid and internally consistent. This command performs basic validation of the Terraform configuration files in the current directory, checking for issues such as missing required attributes, invalid attribute values, and incorrect Terraform code structure.

For example, if you run terraform validate and there are syntax errors in your Terraform code, Terraform will display an error message indicating the line number and description of the issue. If no errors are found, the command will return with no output.

It's recommended to run terraform validate before running terraform apply to ensure that your Terraform code is valid and will not produce unexpected results.

5. In the following Terraform code, what do  name, cidr, and azs represent, and what purpose do they serve?
   module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.2"
 
  name               = var.vpc_name            
  cidr               = var.vpc_cidr_block          
  azs                = var.vpc_azs             
  tags               = merge(var.vpc_tags, {
    Owner       = "btk-platform"
    Environment = "pr0d-east"
  })
}

>
The declarations like name, cidr, and azs are module-specific inputs that are being passed into the child module for resource creation. These allow for customization and flexibility in configuring the VPC module according to specific requirements.
To pass the values to the module, you can specify them in a number of ways, such as:

1. Using command-line flags when running Terraform
2. Storing the values in a Terraform .tfvars file and passing that file to Terraform when running it
3. Using environment variables


# Your team maintains a map of common tags to apply to all resources. Each individual resource also needs its own specific tags. To accomplish this, you have var.common_tags containing shared tags and local.resource_tags containing resource-specific tags. How do you combine both to apply to a resource?

> merge(var.common_tags, local.resource_tags)
The merge() function is used to combine two maps into a single map in Terraform. In this scenario, var.common_tags and local.resource_tags are maps containing tags, so using merge(var.common_tags, local.resource_tags) will combine the shared tags with the resource-specific tags to apply them to the resource effectively.

The merge() function takes two or more maps and combines them into a single map. When there are duplicate keys, values from maps later in the argument list take precedence. This makes it perfect for combining common tags with resource-specific tags, with the latter overriding the former if needed.

> join(var.common_tags, local.resource_tags)
The join() function is used to concatenate elements of a list into a single string with a specified delimiter.

> flatten(var.common_tags, local.resource_tags)
The flatten() function is used to flatten a list of lists into a single list in Terraform. 

> concat(var.common_tags, local.resource_tags)
The concat() function is used to concatenate lists or tuples in Terraform, not maps.


#  Import existing infrastructure into your Terraform workspace

To import manually created resources into Terraform without affecting the availability of the deployed resources, follow these steps:

1. Import the existing resources: You can use the import block to import the existing resources into Terraform.

2. Modify the Terraform configuration: Modify the Terraform configuration to reflect the desired state of the resources. This will allow you to manage the resources using Terraform just like any other Terraform-managed resource

3. Test the changes: Before applying the changes, you can use the terraform plan command to preview the changes that will be made to the resources. This will allow you to verify that the changes will not negatively impact the availability of the resources.

4. Apply the changes: If the changes are correct, you can use the terraform apply command to officially import the resources and pull them under Terraform management

By following these steps, you can start managing manually created resources in Terraform without impacting the availability of the deployed resources.

# You are using a local backend and accidentally delete the terraform.tfstate file for your workspace. What is the most serious consequence?

Terraform’s state file (terraform.tfstate) is how Terraform knows which real cloud resources it created and is responsible for. If you delete or lose that local state file, Terraform has no record of those resources anymore. On the next terraform plan or terraform apply, it will assume the infrastructure does not exist and may try to create new copies, or it may fail to destroy existing resources because it no longer knows they’re there.

In other words, losing state breaks Terraform’s ability to track and safely manage your infrastructure, and recovery usually means importing resources back into state or restoring from backup. Terraform’s documentation explains that state tracks the mapping between your configuration and the actual remote objects, and that Terraform relies on that mapping for planning and updates.

# Aside from traditional code reviews, which Terraform command provides an opportunity for team members to review each other's work before deployment?
The terraform plan command generates an execution plan that describes what Terraform will do when you run terraform apply. This provides an opportunity for team members to review the proposed changes before deployment, allowing them to identify and address any potential issues or mistakes before they are applied to the infrastructure.


# You have a variable containing subnet CIDR blocks as a list: ["10.0.5.0/24", "10.0.0.0/24", "10.0.2.0/24"]. You need to determine how many subnets are in the list to use. Which function returns the number of elements?
> length(var.subnet_cidrs)
The length() function in Terraform is used to return the number of elements in a list. In this case, length(var.subnet_cidrs) will return the number of subnet CIDR blocks in the list, which is what is required to determine how many subnets are in the list.

> keys(var.subnet_cidrs)
The keys() function in Terraform is used to return a list of keys in a map variable

> values(var.subnet_cidrs)
The values() function in Terraform is used to return a list of values in a map 

> contains(var.subnet_cidrs)
The contains() function in Terraform is used to check if a value exists in a list or map.


# Your team uses HCP Terraform with a CLI-driven workflow. After making changes to your configuration locally, you run terraform plan. Where does the plan operation execute?
When you run the terraform plan command in a CLI-driven workflow with HCP Terraform, the plan operation is executed on the HCP Terraform infrastructure. The results of the plan are then streamed back to your terminal for review and analysis, allowing you to see the planned changes and potential impacts directly from the HCP Terraform environment.

# You have split a large module into multiple .tf files and rearranged several resource blocks without changing any arguments or references. What impact should this have when running a terraform plan?
No changes. The order of resource blocks within .tf files or across multiple .tf files does not affect the execution of Terraform plans. Terraform parses and processes all .tf files in a module together, so the rearrangement of blocks should not impact the plan.

# terraform refresh
The command terraform refresh is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure. 

# terraform fmt
The command terraform fmt is used to automatically format all Terraform configuration files in the current directory. It helps maintain consistent formatting across all files without the need for manual editing, making it the ideal choice for quickly updating all files at once.

# The security team requires that you protect sensitive input values, such as API keys or passwords, in Terraform. Which methods follow Terraform guidance for reducing accidental exposure of secrets?
1. Provide secrets as short-lived, ephemeral values from an external system (for example, Vault) at runtime instead of hardcoding static credentials in version-controlled Terraform files.
2. Mark variables as sensitive so Terraform redacts their values in CLI output and logs, limiting accidental disclosure of credentials during plan and apply.

# variable declarations Lists
variable "names" {
  description = "List of user names"
  type        = list(string)
  default     = {}
}

the default value is set as an empty map {}. Terraform will return a type error before apply because an empty map does not match the specified type of list(string).

This variable declaration for a type list is incorrect because a list expects square brackets [ ] and not curly braces. All of the others are correct variable declarations.

Lists/tuples are represented by a pair of square brackets containing a comma-separated sequence of values, like ["a", 15, true].




# variable declarations Map
default value is set as a map with string key-value pairs. 

variable "tags" {
  description = "Map of resource tags"
  type        = map(string)
  default     = {
    Environment = "prod"
    Owner       = "platform-team"
  }
}

# demonstrates the HCL syntax for assigning a value to a variable declared with the type map(string)?
default = { 
  "environment" = "production",
  "owner"       = "dev-team" 
}

This choice correctly demonstrates the HCL syntax for assigning a value to a variable declared with the type map(string). The key-value pairs are enclosed in curly braces, with each key-value pair separated by an equal sign. This format aligns with the HCL syntax for defining a map with string values.



# You're invoking a module that creates a subnet. The root load balancer module requires that subnet’s ID. How should you expose the ID and pass it to the load balancer module?

modules/subnets:

resource "aws_subnet" "bk" {
  vpc_id     = aws_vpc.bk.id
  cidr_block = var.subnet_cidr
 
  tags = {
    Name = "BK Subnet"
  }
}
add an output block to the subnet module and pass the value for the load balancer module using module.subnets.subnet_id

 Use modules in configuration -
Modules also have output values, which are defined within the module with the output keyword. You can access them by referring to 
module.<MODULE NAME>.<OUTPUT NAME>. Like input variables, module outputs are listed under the outputs tab in the Terraform registry.

Module outputs are usually either passed to other parts of your configuration, or defined as outputs in your root module

# A resource was changed manually outside of Terraform. You don't want to make any changes yet, but you want to see how the state would be updated to match the current real-world values. Which command should you run?
> terraform plan -refresh-only
Running terraform plan -refresh-only will show you how the state would be updated to match the current real-world values without making any changes to the infrastructure. This command will refresh the state of the resources without applying any changes.


# What environment variable can be set to enable detailed logging for Terraform?
The TF_LOG environment variable can be set to enable detailed logging for Terraform. It allows users to see more detailed information about the actions Terraform is taking, which can be helpful for troubleshooting and understanding the execution flow.

You can set TF_LOG to one of the log levels TRACE, DEBUG, INFO, WARN or ERROR to change the verbosity of the logs. TRACE is the most verbose and it is the default if TF_LOG is set to something other than a log level name.

# You are using an HCP Terraform workflow that is connected to a VCS repository (VCS-driven workflow) and want to deploy a new resource. Which sequence of steps follows the recommended workflow?
1. Add the new resource block to the Terraform configuration in the repo
2. Open a pull request with the change
3. After the plan is generated, approve the apply in HCP Terraform

# You deployed resources using the CLI, but want to start managing them with Terraform moving forward. What steps are required to start managing resources with Terraform without impacting the resources themselves? 
>  Import existing infrastructure into your Terraform workspace
>
1. add import blocks mapping each address to its real ID
2. write Terraform resource blocks that match the existing settings
3. run terraform apply to import them in state with no changes
    To adopt existing infrastructure, you must have matching resource blocks in code and use imports (import blocks or terraform import) to map real objects into Terraform state. This records them without recreating or modifying the resources; afterward, Terraform manages drift and future changes.

# You are deploying virtual machines across multiple cloud regions. Since images are assigned a unique ID per region, you need to create a variable that looks up the correct ID based on the region name. Which code snippet uses the variable type that is most appropriate for this use case?
variable "image" {
  type = map(string)
  ...
}
Using a map(string) variable type is the most appropriate choice for this use case because it allows you to store key-value pairs, where the key represents the region name and the value represents the corresponding image ID. This way, you can easily look up the correct image ID for a given region when deploying virtual machines across multiple regions.


# Before a new Terraform provider can be used in a configuration, what steps are required?
Declare and configure the provider in the configuration with the required arguments.
Initialize the working directory using terraform init to download and install the provider.


# In the top-level terraform block, which setting specifies a provider’s source and version constraints?
The required_providers setting in the top-level terraform block is used to specify a provider's source and version constraints. This setting allows you to define which providers are required for your Terraform configuration and the specific versions that should be used.

The required_version setting in the top-level terraform block is used to specify the minimum version of Terraform required to run the configuration

The provider setting in the top-level terraform block is used to configure a specific provider for a particular resource or module within your Terraform configuration.

The backend setting in the top-level terraform block is used to configure the backend where Terraform stores its state data. 

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.5.0"
    }
  }
}
In this example, we're specifying that we require version 6.5.0 of the AWS provider, which is hosted at the hashicorp/aws source. Note that the version constraint syntax allows you to specify a range of versions using operators such as >= and <=.
When you run terraform init with this configuration, Terraform will download and install the specified version of the AWS provider, and will use it for all subsequent Terraform commands for that module. If the specified version is not available, Terraform will return an error and fail to initialize the configuration.

# You’re moving a project to a remote backend so the state is stored in Amazon S3. How do you correctly configure and initialize the backend?
Defining the S3 backend in the terraform block and running terraform init is the correct way to configure and initialize the backend for storing state in Amazon S3. This approach ensures that the state is migrated from the local backend to the remote S3 backend.
terraform {
  backend "s3" {
    bucket = "btk-bucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}

# You're configuring an S3 backend for your Terraform project. You want to keep sensitive values, such as the bucket name and region, out of version control while keeping other backend configuration in your code. Which approach correctly implements partial backend configuration?

define the backend block with only the type, then pass the bucket and region values using -backend-config flag during terraform init
terraform { 
  backend "s3" { } 
}
then supply sensitive or environment-specific values using -backend-config flags: terraform init -backend-config="bucket=my-bucket" -backend-config="region=us-west-2". 
Alternatively, you can use a backend configuration file with -backend-config=path/to/file


# A module creates VMs with the vSphere provider. It includes arguments such as datastore = "DS1", network_label = "VM Network", and a folder = "Dev/Apps". You need the same module to work in Lab, QA, and Prod vCenter environments without code changes.
What is the most appropriate change to enable the reuse of this module?
Convert the hard-coded values to input variables and provide environment-specific settings via tfvars or variable sets at plan/apply.
Input variables serve as parameters for a Terraform module, allowing aspects of the module to be customized without altering the module's source code, and enabling modules to be shared across different configurations.

# In the snippet below, where does the value for vpc_security_group_ids come from?



module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"
 
  name            = "pr0d-east-app"            
  instance_count  = 2
  ami             = "ami-0c5204531f799e5-2"
  instance_type   = "t3.micro"
 
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
 
  tags = { Owner = "btk-platform", Env = "pr0d-east" }
}

The value for vpc_security_group_ids comes from the output of another module, specifically the default_security_group_id output of the vpc module. This allows the ec2_instances module to reference the security group ID created by the vpc module for use in configuring the EC2 instances.

# One of your application teams needs to share third-party credentials across multiple workspaces. What is the most appropriate way to configure HCP Terraform and easily meet these requirements? 
1. Creating a variable set that includes the third-party credentials makes it easy to manage and share these sensitive pieces of information across multiple workspaces. By defining the credentials in a variable set, they can be easily applied to different projects and workspaces.
2. Grouping the team's workspaces into a project allows for centralized management and sharing of resources, including variables like third-party credentials. This ensures that all workspaces within the project have access to the same set of credentials.
3. Applying the variable set to the project ensures that all workspaces within the project have access to the third-party credentials. This simplifies the process of sharing and managing sensitive information across multiple workspaces within the same project.
HCP Terraform variable sets are groups of reusable variables created at the organization level. A variable set can have one of three scopes:

1. Global: It will apply to all current and future workspaces within an organization.

2. Project-specific: It will apply to all current and future workspaces within the selected projects.

3. Workspace-specific: It will apply only to the selected workspaces.

# You have an existing Google Cloud Storage bucket that was created manually. You want to bring it under Terraform management using a modern config-driven approach, so you add the following configuration:



import {
  to = google_storage_bucket.data_lake
  id = "bk-existing-bucket"
}
 
resource "google_storage_bucket" "data_lake" {
  name     = "bk-existing-bucket"
  location = "US"
}

Starting with recent versions of Terraform, import is now part of the standard config-driven workflow using import blocks. When you add an import block to your configuration, running terraform plan will show that Terraform intends to import the existing resource, and terraform apply will actually perform the import operation. 

Running terraform plan followed by terraform apply is the correct approach to import the existing Google Cloud Storage bucket resource into Terraform management. This sequence lets you preview the changes Terraform will make before applying them.

# Your team manages infrastructure across multiple AWS regions using Terraform. You want to see a complete list of all resources currently tracked in your Terraform state file, but don't need the detailed attributes of each resource. Which command should you use?

> terraform state list
The terraform state list command is used to quickly list all resources currently tracked in the Terraform state file without displaying the detailed attributes of each resource. This command provides a high-level overview of the resources being managed by Terraform.

# You're refactoring a large Terraform configuration, splitting a monolithic file into multiple smaller files and reorganizing resource blocks. Before running terraform plan, what's the fastest way to verify you didn't introduce any syntax errors during the refactoring?
> terraform validate
Running terraform validate is the fastest way to verify that you didn't introduce any syntax errors during the refactoring process. This command checks the configuration files for syntax errors, ensuring your Terraform code is valid and can be executed successfully.

> terraform fmt -check
 The "terraform fmt -check" command is used to check whether Terraform files are properly formatted without making any changes. It validates file formatting and ensures consistency across all files in the repository before merging into the main branch.

# Your team has multiple infrastructure projects with different compliance requirements. Some projects require advisory policy checks while others need mandatory enforcement. How should you configure policies in HCP Terraform to meet these varying requirements?
Configuring different enforcement levels for each policy set allows you to meet the varying compliance requirements of different projects. By applying these policies to the appropriate workspaces or projects, you can ensure that advisory policy checks and mandatory enforcement are implemented where needed.

# What benefits would you see by using a multi-cloud and provider-agnostic tool like Terraform?
Reduces operational overhead by allowing teams to learn and govern a single tool across all environments.
This streamlines the learning process and governance, as teams only need to become proficient in one tool for all environments.
Terraform provides a consistent declarative workflow and language across various cloud providers and hypervisors. This consistency allows for easier management of infrastructure and deployments, as the same syntax and workflow can be used regardless of the underlying provider.

#  provider configurations in modules?
1. Child modules automatically inherit the default provider configurations from their parent module. This allows for a seamless propagation of provider configurations throughout the module hierarchy without the need for explicit redefinition in each child module.
2. A module intended to be called by one or more other modules must not contain any provider blocks. A module containing its own provider configurations is not compatible with the for_each, count, and depends_on arguments.
3. The providers argument in a module block allows explicit passing of specific provider configurations. This feature enables users to define and pass specific provider configurations to a module, providing flexibility and customization in managing provider settings within the module.

# Why should a user specify provider version constraints in their Terraform configuration?
Providers are developed and released independently of Terraform, so newer versions may introduce breaking changes that could impact the functionality of your infrastructure. Specifying version constraints ensures that you are using a compatible provider version with your Terraform configuration.

# Terraform files should be ignored by Git when committing code to a repo?
The terraform.tfstate file contains the current state of your infrastructure managed by Terraform. It should not be committed to version control as it can contain sensitive information and should be managed separately using remote state storage.

# You maintain an existing Terraform configuration that uses a public module pinned to a specific version. A new minor version 5.3.0 of the module is available, and you want your configuration to use it. What steps are required to update the module version safely? (select two)

module "compute" {
  source  = "azure/compute/azurerm"
  version = "5.2.0"
}
run "terraform init -upgrade" to download the new module version and update your configuration to use the latest available version. This command is specifically designed to safely upgrade modules in your Terraform configuration.

# You are reviewing the following Terraform configuration in main.tf. Which statements about this configuration are correct? (select two)



module "servers" {
  source  = "./modules/btk-cluster"
  servers = 5
}

1. The source ./modules/btk-cluster indicates that btk-cluster is a local child module located in the modules directory relative to the root module. This allows the root module to reference and use the resources defined in the child module.
2. main.tf is indeed the root module in this configuration, as it is the main entry point for the Terraform configuration. It is where the module servers block is defined, which calls the child module btk-cluster.

To call a module means to include the contents of that module into the configuration with specific values for its input variables. Modules are called from within other modules using module blocks. A module that includes a module block like this is the calling module of the child module.

The label immediately after the module keyword is a local name, which the calling module can use to refer to this instance of the module.


# Your organization wants to ensure that third-party security scanning tools can review Terraform plans before any infrastructure changes are applied. Which HCP Terraform feature allows you to integrate external tools into the workflow between the plan and apply phases?
> run tasks
1. This is the correct choice because HCP Terraform run tasks allow you to integrate external tools into the workflow between the plan and apply phases. This feature lets you run custom scripts or tools to perform additional checks or validations on Terraform plans before applying changes to the infrastructure.

2. They execute between the plan and apply phases, enabling you to call external APIs for tasks like security scanning, cost estimation, or custom validation. Run tasks can be configured as advisory (warnings only) or mandatory (blocking apply if they fail), giving you flexible control over external validations. This differs from run triggers, which automatically start runs in other workspaces, and health checks, which monitor drift and resource health over time.

> run triggers
Triggers are typically used for automation or event-driven actions within Terraform configurations.

> health checks
Health checks are typically used to monitor the status and health of resources.

> change requests
Change requests are typically used to track and manage proposed changes to infrastructure configurations.


# What is the .terraform.lock.hcl file and when does Terraform create or modify it?
The ".terraform.lock.hcl" file is a dependency lock file used by Terraform. It is created or updated every time you run "terraform init".

The dependency lock file is a file that belongs to the configuration as a whole, rather than to each separate module in the configuration. For that reason, Terraform creates it and expects to find it in your current working directory when you run Terraform, which is also the directory containing the .tf files for the root module of your configuration.

The lock file is always named .terraform.lock.hcl, and this name is intended to signify that it is a lock file for various items that Terraform caches in the .terraform subdirectory of your working directory.

Terraform automatically creates or updates the dependency lock file each time you run the terraform init command. You should include this file in your version control repository so that you can discuss potential changes to your external dependencies via code review, just as you would discuss potential changes to your configuration itself.

# Your team wants to enforce consistent formatting across all Terraform files before merging code into the main branch. You're setting up a CI/CD pipeline and need a command that checks whether files are properly formatted without making changes. Which command should you use?
> terraform fmt -check

# Multiple providers can be declared within a single Terraform configuration file.
> Yes

Multiple providers can be declared within a single Terraform configuration file. In fact, it is common to declare multiple providers within a single configuration file, particularly when managing resources across multiple cloud providers.

When declaring multiple providers within a single configuration file, each provider should have a unique configuration block that specifies its name, source, and any required settings or credentials. Here's an example of what a configuration block for two different providers might look like:



terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.5.0"
    }
    google = {
      source = "hashicorp/google"
      version = "4.5.0"
    }
  }
}
 
provider "aws" {
  region = "us-west-2"
}
 
provider "google" {
  project = "my-project"
}


In this example, we have declared two providers (aws and google) within a single configuration file. The terraform block declares the required providers, while the provider blocks specify the provider-specific settings and credentials.

# Your team uses Vault for short-lived credentials and stores Terraform state in a remote backend. Which statements reflect best practices for managing sensitive data and state? 
1. If you manage any sensitive data with Terraform (like database passwords, user passwords, or private keys), treat the state itself as sensitive data.
When using local state, the state file is stored in plain-text JSON files.
2. Storing Terraform state remotely can provide better security.
   
3. Storing Terraform state in plain text when using local state is a security risk, as it exposes sensitive information. It is recommended to use a remote backend to store state securely and prevent unauthorized access.
   
4. Restricting access to Terraform state is crucial to prevent unauthorized access to sensitive data. By auditing changes to the state, you can track who made modifications and when they were made, enhancing security and compliance.

5. Using a properly configured remote backend for storing Terraform state enhances security by encrypting the state data and providing access controls. This ensures that sensitive information is protected and only accessible to authorized users.


# You're deploying a GCP Compute Engine instance and want to verify that the instance receives a public IP address after creation. If it doesn't, you want Terraform to fail with an error. Which validation mechanism should you use?
> add a postcondition in the lifecycle block of the instance resource

Postconditions are evaluated after a resource is created or updated and can verify that the resource was created with expected attributes. Since you need to check the instance's public IP after creation, a postcondition is appropriate. 

You would add it to the lifecycle block with a condition like self.network_interface[0].access_config[0].nat_ip != "". If the condition fails, Terraform will error and the operation fails, ensuring you don't proceed with infrastructure that doesn't meet your requirements


# In HCP Terraform, what scope levels are available for providing variables to workspaces?
1. You can define variables directly in a single workspace. Those variables apply to all runs in that workspace and are not shared with other workspaces.
2. Applying variables to all current and future workspaces and Stacks within a project using a variable set provides a high-level scope that ensures consistency and standardization across all workspaces within the project. This approach simplifies the management of variables and configurations across multiple environments.
3. Having multiple workspaces with a variable set enables the reuse of variables across different workspaces. This scope level allows for consistency in variable values across multiple workspaces, making it easier to manage and maintain configurations.

4. Run-specific variables can be used by setting Terraform variable values using the -var and -var-file arguments in a single workspace

You can create a variable set by adding variables to the variable set and then applying a variable set scope so it can be used by multiple HCP Terraform workspaces

You can also apply the variable set globally, which will apply the variable set to all existing and future workspaces.

# Which Terraform command will force a resource to be destroyed and recreated even if there are no configuration changes that would require it?
> terraform apply -replace=<address>
The terraform apply -replace= command is used to force a resource to be destroyed and recreated, even if there are no configuration changes that would require it. This is achieved by specifying the resource address that needs to be replaced, ensuring that the resource is recreated with the latest configuration.

# A root module includes several variables in terraform.tfvars. You add a child module as shown below. What values can the child module access by default?

module "web" {
  source = "./modules/web"
}

By default, child modules in Terraform do not have access to root variables defined in terraform.tfvars. The child module needs to explicitly receive values through the module block to access specific variables from the root module.

# Understand best practices for managing sensitive data, including secrets management with Vault
Marking an output as sensitive in Terraform only affects the display of the value in the CLI output and logs. It does not prevent the value from being stored in the Terraform state file, so it can still be accessed by anyone with access to the state file.

Use the sensitive argument on variable and output blocks when you want to redact those values from Terraform CLI log output and the HCP Terraform UI. Terraform also treats any expressions that reference a sensitive variable or output as inherently sensitive.

#  Describe state locking -
 Not all remote backends support state locking. For example, the S3 backend requires additional configuration with DynamoDB to enable state locking - S3 alone does not provide locking. Similarly, some backends, like HTTP, may not support locking depending on the implementation. However, backends like HCP Terraform, Terraform Enterprise, and properly configured S3 do support state locking. When choosing a remote backend, verify that it supports state locking and is properly configured, especially in team environments where concurrent operations are likely.

 # You discovered a module on the Terraform Registry that will provision the resources you need. What other information can you find on the Terraform Registry to help you quickly use this module? 
 1. Dependencies to use the module are important information that you can find on the Terraform Registry. Understanding the dependencies of a module will help you ensure that you have all the necessary components in place before using the module in your Terraform configuration.
 2. Required input variables are essential information that you can find on the Terraform Registry for a module. Knowing the required input variables will help you understand what parameters need to be provided when using the module in your Terraform configuration.
 3. A list of outputs is crucial information that you can find on the Terraform Registry for a module. Outputs define the values that the module will return after provisioning the resources, allowing you to access and use those values in other parts of your Terraform configuration.


# You're comparing local state versus remote state backends for your team's infrastructure. Which statements below correctly describe the key differences or tradeoffs between these approaches?
1. Remote backends provide centralized state access for team collaboration, while local state requires manual file sharing between team members
2. Local state is simple to set up with no additional infrastructure required, while remote backends require configuration and maintenance of backend services

3. Remote backends typically provide encryption at rest and access controls for state data, while local state security depends entirely on filesystem permissions

# Manage resource drift and Terraform state

 While moved blocks don't need to remain in your configuration permanently, you should keep them for at least one full apply cycle after all team members and automation systems have run terraform apply with the moved block present. Removing a moved block too quickly can cause problems if someone runs Terraform with an old state file that hasn't yet processed the move - Terraform would interpret the old resource address as deleted and the new one as needing to be created. Best practice is to keep moved blocks through a few apply cycles or until you're confident all state files have been updated, then remove them in a future refactoring effort.

#  Rahul deployed multiple VMs outside the Terraform workflow, and now your team is unsure which VM is managed by Terraform. What approach would best help you identify the Terraform-managed VM without making any changes to the infrastructure?
Use Terraform state commands terraform state show to match the tracked VM’s ID with the list of active VMs.

# You are troubleshooting an issue where Terraform is modifying certain resource attributes during apply operations that you didn't expect. You suspect the provider is interpreting your configuration differently than expected. What is the primary benefit of enabling Terraform logging in this situation?

Logging will show you the detailed interactions between Terraform and the provider API and help you identify where the unexpected behavior occurs

Enabling Terraform logging through the TF_LOG environment variable provides detailed visibility into Terraform's operations, including API calls, provider interactions, and decision-making processes. This is particularly valuable when troubleshooting unexpected behavior, as it lets you see exactly what Terraform is sending to and receiving from provider APIs. Logging does not modify behavior, create backups, or perform validation - it simply records detailed information about what Terraform is doing, which helps you understand and diagnose issues.

# You have created a brand-new Terraform repo that has no backend block. After successfully running your first terraform apply, where does Terraform store state by default?
With no backend configured,
Terraform stores state by default in the current working directory in a file named "terraform.tfstate". This is the default behavior when no backend block is specified in the Terraform configuration.

# You want to start managing resources that were not originally provisioned through infrastructure as code. Before you can import the resources, what must you do before running the terraform import command?
update the Terraform configuration file to include new resource blocks that match the resources you want to import

# You have a root module that calls the child module modules/web. In modules/web/main.tf, a developer added name = "${var.env}-app".
Declare variable "env" {} in the child module and pass it from root using env = var.env