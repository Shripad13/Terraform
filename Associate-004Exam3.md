

# You want to dynamically create a server name by combining three string variables with hyphens to produce prod-us-east-web. Which of the following expressions would accomplish this?
> name = join("-", [var.environment, var.region, var.app])

The join() function takes a delimiter as the first argument and a list as the second argument.

The join function in Terraform is used to concatenate elements of a list into a single string with a specified separator. In this case, using join with a hyphen separator between the variables.

# Other 
> format("%s+%s+%s", var.environment, var.region, var.app)
The format function in Terraform is used to create formatted strings by replacing placeholders with values.

> name = concat(var.environment, var.region, var.app)
The concat function in Terraform is used to concatenate multiple lists or strings together.

> name = merge(var.environment, var.region, var.app)
The merge function in Terraform is used to merge multiple maps together.


# Your configuration uses a module stored on a private registry that is configured with this version argument: version = "~> 3.2.0". The registry has versions 3.2.0, 3.2.5, 3.3.0, and 4.0.0 available for this module. Which version will Terraform download during terraform init?
When using the ~> 3.2.0 version constraint, Terraform will download the highest available version that is within the same minor version range as the specified version. In this case, 3.2.5 is the highest available version within the 3.2.x range, so Terraform will download version 3.2.5 when running a terraform init.    

# You have executed a terraform apply using a complex Terraform configuration file. However, a few resources failed to deploy due to incorrect variables. After the error is discovered, what happens to the resources that were successfully provisioned?
The resources that were successfully provisioned will remain as deployed, and the other resources are marked as tainted.

# All your infrastructure is managed by Terraform, but engineers occasionally make small updates directly on the target platform. Which Terraform command can identify changes to the actual infrastructure and reflect them in the Terraform state?
> terraform apply -refresh-only
The terraform apply -refresh-only command syncs the state file with the real infrastructure (detects drift and updates state), but it does not change the infrastructure to match the configuration.

# Describe state locking

If the backend supports locking, the first terraform apply will lock the file for changes, preventing the second user from running the apply.

If the backend does not support locking, the state file could become corrupted.

# Destroy Terraform-managed infrastructure

When destroying resources, Terraform respects the dependency graph in reverse order. Since the subnet depends on the virtual network (it references the VNet name), and the virtual network depends on the resource group (it references the RG name), Terraform will destroy them in reverse dependency order: subnet first, then virtual network, then resource group. This ensures that dependent resources are removed before the resources they depend on, preventing errors that would occur if Terraform tried to delete a resource group while it still contained a virtual network.

# Explain how Terraform manages multi-cloud, hybrid cloud, and service-agnostic workflows

1. Terraform allows for flexibility in storing state data. While it is recommended to store state in the same cloud provider where resources are being provisioned, it is possible to store the state in one cloud's remote backend while deploying resources in another cloud provider. This separation can be useful for specific organizational requirements.
2. The same configuration can deploy QA and Staging by supplying different variable values or files
3. It can manage resources across multiple cloud providers in the same run when both providers are configured.  

# You have a root module with a variable defined, as shown in the exhibit below. Inside a child module, you write name = var.environment as part of an expression when creating a resource. What will happen when you run terraform plan?

variable "environment" { 
  default = "production" 
}
 
module "web" {
  source = "./modules/web"
}

Terraform will return an error stating that var.environment is not declared in the child module because variables defined in the root module are not automatically accessible in child modules. The child module needs to explicitly declare and pass the variable to use it.

# A high-security application requires a randomly generated, one-time API key to be passed to a new server resource during its initial creation. Due to strict security and compliance policies, this generated key is explicitly forbidden from being written to the Terraform state file.
Answer -
ephemeral "random_password" "db" {
  length = 20
}
 
resource "aws_db_instance" "main" {
  engine              = "postgres"
  username            = "btk-admin"
  password_wo         = ephemeral.random_password.db.result
  password_wo_version = 1
}
The ephemeral block with the random_password resource generates a random password with a length of 20 characters. The password generated is not stored in the Terraform state file, meeting the requirement of not persisting the API key. 
The password_wo attribute in the aws_db_instance resource uses the generated password without writing it to the state file.

# Which feature of HCP Terraform can be used to enforce fine-grained policies to enforce standardization and cost controls before resources are provisioned with Terraform?
> Sentinel and OPA
Sentinel and OPA are both policy as code tools that can be integrated with HCP Terraform to enforce fine-grained policies. These tools allow organizations to define and enforce policies that govern infrastructure provisioning, ensuring standardization and cost controls are in place before resources are provisioned with Terraform.


# terraform state list
The terraform state list command is the most appropriate for quickly listing the resources currently being managed in a Terraform workspace. This command provides a concise list of resource names without displaying detailed configuration or attribute information, allowing for a quick count of resources.



# Your teammate wants you to use terraform import to bring an existing Google Cloud Storage bucket under Terraform management. They expected that after running the import, the Terraform configuration file would automatically be populated with all the bucket's current settings, but it wasn't. What should you tell your teammate about Terraform's import functionality?
Importing only adds the resource to Terraform state and you need to add the resource block to match the existing bucket settings.

# You are using the CLI and want your local Terraform configuration to run in HCP Terraform and store state there. How should you configure this in your code?

Add a cloud block inside the terraform block that sets the HCP Terraform organization and workspace to use for this working directory.

# .tfvars file
The .tfvars file in Terraform allows you to provide specific values for variables that override the default values set in the main configuration files. By using a .tfvars file, you can customize variables, including those related to the current working directory, without directly modifying the main configuration.

Terraform automatically loads all files in the current directory with the exact name terraform.tfvars or matching *.auto.tfvars. You can also use the -var-file flag to specify other files by name.


> .tf file
The .tf file is the primary configuration file in Terraform where you define your infrastructure resources and configurations. 

> .tfstate file
The .tfstate file in Terraform is used to store the state of the infrastructure managed by Terraform.

> .tmpl file
The .tmpl file extension is commonly associated with template files in Terraform.


# terraform init -upgrade command perform?
> terraform init -upgrade
update all previously installed plugins and modules to the newest version that complies with the configuration’s version constraints

# You've completed writing your Terraform configuration and run terraform plan. The output shows +/- 4 resources, indicating that some resources are being destroyed and recreated. Before you run terraform apply, which actions should you take? 
> review which resources are being replaced and understand why Terraform is forcing replacement. This step helps in identifying any potential issues or unexpected changes that may occur during the apply process.
> check if the resources being replaced will cause downtime or data loss


# Your team manages long-lived VMs with a configuration management tool, but drift and rollbacks are frequent. You’re evaluating alternatives. Which option best reflects an IaC advantage over traditional configuration management?
Using declarative IaC and immutable infrastructure allows you to define the desired state in code, easily replace resources, and version everything.

# When running the terraform validate command, which issue will be brought to your attention?
> a variable is being used in a resource block but has not been declared
When running the terraform validate command, it checks the syntax and configuration of the Terraform files. If a variable is being used in a resource block but has not been declared, Terraform will flag this as an issue because it can lead to errors during the execution of the infrastructure provisioning process.

The terraform validate command validates the configuration files in a directory. It does not validate remote services, such as remote state or provider APIs.
It is thus primarily useful for general verification of reusable modules, including correctness of attribute names and value types.

> The alignment of parameters inside a resource block with spaces is a formatting issue and not directly related to the validation of the Terraform configuration. 

# A developer has a valid Terraform configuration and has already successfully initialized the working directory. Assuming the developer approves the execution plan, which of the following actions will the terraform apply command perform?
1. Update the state file to match the changes made to the infrastructure during the execution.
2. Create, update, or delete infrastructure in the target environment based on the changes specified in your Terraform files.

# You have an existing VPC in your account and have added the data block to your configuration, as shown below. How would you reference the id of the VPC?

data "aws_vpc" "production" {
  tags = { Name = "prod" }
}

> data.aws_vpc.production.vpc.id ---> Incorrect
The inclusion of the vpc keyword in this choice is incorrect. When referencing attributes of a data block resource in Terraform, you should directly access the attribute without any additional keywords.

> data.aws_vpc.production.id    ----> CORRECT
 you read attributes from data sources with the pattern
> data.<TYPE>.<NAME>.<ATTRIBUTE>

# Configure remote state using the backend block

Backend configuration blocks only accept literal values - you cannot use variables, resource attributes, or any computed values inside a backend block. "This is because the backend must be initialized before Terraform can evaluate variables or resources. "
Valid backend configuration includes static strings, numbers, and booleans like bucket = "my-state-bucket", key = "terraform.tfstate", and region = "us-east-1". 
If you need dynamic backend configuration, you must use partial configuration with -backend-config flags or configuration files that are generated outside of Terraform. This limitation exists because Terraform needs to access the backend before it can process the rest of your configuration.


# Understand and use complex types
What is the key difference between map(string) or an object type for storing AWS instance configuration two types?

The fundamental difference is that object types have a fixed schema with predefined attribute names and their types, while map have dynamic keys, but all values must be the same type. 
An object type like object({ instance_type = string, ami_id = string, key_name = string }) enforces exactly these three attributes with string types. 
A map(string) would allow any keys, but all values must be strings. Objects are appropriate when you know the exact structure needed and want type safety for each attribute. Maps are better when you need flexible keys with consistent value types, like the AMI-per-region scenario.

# When using HCP Terraform, what is the simplest way to maintain the security and integrity of modules when multiple teams across different projects use them?
To make managing approved modules easier, you can host all your approved Terraform modules in your organization's Private Registry on HCP Terraform.
Use the HCP Terraform Private Registry to make sure your organization only uses approved modules.
This improves security, keeps infrastructure deployments consistent, and lowers the risk of using unverified or potentially harmful modules in your Terraform setups.

# Terraform provider
it defines the resource schemas, handles authentication, and performs operations against the API of the SaaS. It also exposes resources and data sources to Terraform configurations, allowing you to manage the SaaS resources using Terraform.

# Which statements most accurately describe the benefits of using modules in Terraform?
1. promote reuse and standardization of infrastructure patterns
2. can be sourced locally or remotely (e.g., VCS, registry, HTTP)
3. support version pinning/constraints to control upgrades and maintain compatibility

# What are the primary benefits of Terraform state?
1. tracks the current state of your infrastructure, enabling it to understand what resources exist and need to change
2. maintains relationships between resources, helping Terraform understand dependencies and ensure proper resource ordering
3. allows multiple team members to collaborate safely by tracking who is making changes and preventing concurrent modifications

# Write Terraform configuration using multiple providers

the alias argument to define multiple configurations for the same provider. Defining multiple provider aliases lets you specify which provider configuration to use for individual resources, data sources, or modules.

To create multiple configurations for a given provider, include multiple provider blocks with the same provider name, then add the alias argument to each additional provider configuration to give it a unique identifier. Example:


provider "exampleName" {
  region = "us-east-1"
}
 
provider "exampleName" {
  alias  = "west"
  region = "us-west-1"
}

If no provider is indicated for a resource, it will default to the first provider block.


# A provider alias is used for what purpose in a Terraform configuration file?
A provider alias is used to define multiple configurations of the same provider in a Terraform configuration file. This allows you to have different configurations for the same provider, such as different authentication settings or regions, and bind specific resources to each configuration.

# Your team needs to capture Terraform logs for a production deployment. You want the logs saved to a file rather than displayed in the terminal so you can review with senior engineers. Which environment variable should you set to specify the log file location?
> TF_LOG_PATH
Setting the "TF_LOG_PATH" environment variable allows you to specify the location where Terraform logs will be saved. 

The TF_LOG_PATH environment variable specifies the file path where Terraform should write its logs. 
When you set both TF_LOG and TF_LOG_PATH, Terraform will write detailed logs to the specified file instead of displaying them in the terminal. 
This is particularly useful for production deployments where you want to capture logs for later analysis without cluttering terminal output. 
For example, you could set TF_LOG_PATH=/var/log/terraform/deploy.log to save logs to that specific file location.

# Your team is using two HCP Terraform workspaces. The prod-webserver workspace has successfully deployed an Azure VM. You're now working in the prod-dns workspace and need to use the public IP to create a DNS record. The webserver IP keeps changing, so you don't want to manually update a variable whenever it changes.

What can you add to the prod-dns workspace to automatically retrieve the IP from prod-webserver?

> a tfe_outputs data source that references the prod-webserver workspace
By adding a tfe_outputs data source that references the prod-webserver workspace, you can automatically retrieve the output values from the prod-webserver workspace, including the public IP address of the Azure VM. This allows you to dynamically use the latest IP address without manually updating any variables.

> "Dynamic blocks" are used to generate multiple similar resources or configurations based on a set of dynamic values, not to retrieve specific data from another workspace.
>

# Given the configuration below, which expression correctly references the EC2 instance created for the frontend application?



resource "aws_instance" "svc_apps" {
  for_each = {
    "auth"     = "security"
    "billing"  = "finance"
    "frontend" = "ui"
    "worker"   = "batch"
  }
  ...
}

>Answer ---> aws_instance.svc_apps["frontend"]
The correct way to reference the resource provisioned for the frontend application is by using the syntax aws_instance.svc_apps["frontend"]. This syntax allows you to access the specific resource using the key frontend defined in the for_each block.

> Incorrect Answer --> aws_instance.svc_apps.frontend
The syntax aws_instance.svc_apps.frontend is incorrect because it does not account for the use of the key frontend in the for_each block


#  Refer to resource attributes and create cross-resource references

The following specifications apply to index values on modules and resources with multiple instances:

[N] where N is a 0-based numerical index into a resource with multiple instances specified by the count meta-argument. Omitting an index when addressing a resource where count > 1 means that the address references all instances.

["INDEX"] where INDEX is an alphanumeric key index into a resource with multiple instances specified by the for_each meta-argument.

https://developer.hashicorp.com/terraform/language/meta-arguments/for_each#referring-to-instances


<TYPE>.<NAME> or module.<NAME>: For example, azurerm_resource_group.rg refers to the block.
<TYPE>.<NAME>[<KEY>] or module.<NAME>[<KEY>]: For example, azurerm_resource_group.rg["a_group"] and azurerm_resource_group.rg["another_group"] refer to individual instances.

# A remote backend configuration is required for using Terraform.
>False
While it is recommended to use a remote backend configuration for Terraform to enhance scalability and collaboration, it is not mandatory. Terraform can function with a local backend configuration, storing state files on the local machine, although using a remote backend offers benefits such as improved security and accessibility.

 If you don't provide a backend configuration, Terraform will use the local default backend. 
 > Remote Backends are completely optional. 
 You can successfully use Terraform without ever having to learn or use a remote backend. 
 However, they do solve pain points that afflict teams at a certain scale. If you're an individual, you can likely get away with never using backends.

 # Your team deployed an Azure SQL Database last week. Now you need to create a new web app that connects to this database. The database's connection string is automatically generated by Azure during deployment. How should you pass the connection string to your web app resource in Terraform?
 you can reference the database resource's connection string attribute directly in the web app configuration in Terraform. This ensures that the web app will always use the correct and up-to-date connection string without the need for manual intervention.

  > using azurerm_mssql_database.main.connection_string. This approach retrieves the dynamically generated value and automatically creates a dependency, ensuring the database is created before the web app. Hardcoding values or using variables requires manual intervention and doesn't establish proper resource dependencies.


  # Your cluster team provides a list of Kubernetes namespaces to create, as shown below. You must create one kubernetes_namespace per entry using for_each. Which configuration correctly uses the complex type?

variable "namespaces" {
  type = list(string)
  default = [
    "platform", 
    "apps", 
    "observability"
  ]
}


> Correct answer
resource "kubernetes_namespace" "ns" {
  for_each = toset(var.namespaces)
  metadata { 
    name = each.value 
  }
}

The configuration correctly uses the complex type by converting the list of strings into a set with toset(). It then iterates over each value in the set to create a kubernetes_namespace resource with the name set to the value of each entry in the list.

> for_each requires a map or set. Converting the list(string) to a set(string) with toset() is a valid way to meet the requirements. The namespace name can be set using each.value.

#
resource "kubernetes_namespace" "ns" {
  for_each = tomap(var.namespaces)
  metadata {
    name = each.value 
  }
}
Explanation
tomap(var.namespaces) is invalid because tomap() expects a collection of key/value pairs, not a bare list of strings.

#
resource "kubernetes_namespace" "ns" {
  for_each = { 
    for i, n in var.namespaces : i => n 
  }
  metadata { 
    name = each.key 
  }
}
Explanation
The comprehension builds a map of {index => name}, but the resource uses each.key, which is the numeric index (e.g., 0, 1) rather than the actual namespace string.


# 
resource "kubernetes_namespace" "ns" {
  for_each = var.namespaces
  metadata {
    name = each.key 
  }
}
Explanation
for_each can’t take a list; it must be a map or set. Also, with for_each over a list (even if it worked), each.key would be an index, not the namespace name you want.


# After running terraform apply and provisioning new infrastructure, a team member accidentally deletes the terraform.tfstate file from the remote directory. What happens when you run terraform plan?
Terraform will show that it needs to create all resources as new because it has no record of existing infrastructure.
 When you run terraform plan after losing the state file, Terraform will treat your configuration as entirely new and attempt to recreate all resources, potentially causing conflicts with existing infrastructure. This is why proper state management and backups are essential in production environments.

 # Your team deployed an Azure SQL Database using Terraform and needs to share the connection string with the application team. You create an output block with the sensitive flag set to true. However, a team member reports that they can still see the connection string when running terraform show. Why does this happen?
 The sensitive flag only prevents the value from appearing in the CLI output, but it is still stored in plain text in the state file.
  which team members can access with terraform show.
  The sensitive flag should be set in the output block to hide sensitive information.

# You need to verify that an Azure resource group exists before creating resources in it. You're using a data source to look up the resource group. Which configuration correctly adds validation to ensure the data source returns a result?

Your answer is correct
data "azurerm_resource_group" "main" {
  name = var.rg_name
  
  lifecycle {
    postcondition {
      condition     = self.id != ""
      error_message = "Resource group not found."
    }
  }
}
Yes, this is the correct configuration as it utilizes the postcondition block within the lifecycle to validate the data source result. By checking if the self.id attribute is not empty, it ensures that the resource group exists before proceeding with resource creation.

Data sources support postconditions in their lifecycle blocks to verify that the query returned expected results. Since data sources are read operations, you use postconditions (not preconditions) to validate the data after it's been fetched. 
The postcondition checks self.id != "" to ensure the resource group was found. This validation happens during the plan and apply phases and will cause Terraform to error if the resource group doesn't exist.

# You’ve updated a production load balancer using Terraform. Before making changes, you must (a) preview the exact set of actions as a dry run and (b) ensure that the same reviewed actions are applied later without drift.

> terraform plan -out=lb.tfplan → terraform apply lb.tfplan

The command terraform plan -out=lb.tfplan will generate a plan of the exact set of actions that Terraform will take when applying changes. By using the -out flag, the plan will be saved to a file named lb.tfplan. Later, running terraform apply lb.tfplan will ensure that the reviewed actions from the plan are applied without any drift, as the plan file will be used as input for the apply command.

# Understand best practices for managing sensitive data, including secrets management with Vault

1. using a declared variable
2. retrieving the credentials from a data source, such as HashiCorp Vault
3. using a tfvars file
When using sensitive values in your Terraform configuration, all of the configurations mentioned above will result in the sensitive value being written to the state file. Terraform stores the state as plain text, including variable values, even if you have flagged them as sensitive. 
Terraform needs to store these values in your state so that it can tell if you have changed them since the last time you applied your configuration.

Terraform runs will receive the full text of sensitive variables and might print the value in logs and state files if the configuration pipes the value through to an output or a resource parameter. 
Additionally, Sentinel mocks downloaded from runs will contain the sensitive values of Terraform (but not environment) variables. Take care when writing your configurations to avoid unnecessary credential disclosure. (Environment variables can end up in log files if TF_LOG is set to TRACE.)



# You refactored a module and renamed a resource as shown in the code example below. When running terraform plan, Terraform wants to destroy aws_s3_bucket.logs and create aws_s3_bucket.app_logs.

How can you make this a config-driven change so Terraform will update state to the new address without replacing it?

# ORIGINAL
resource "aws_s3_bucket" "logs" {}
 
# UPDATED
resource "aws_s3_bucket" "app_logs" {}

> add a moved block to indicate the address change directly in your configuration.

By adding a "moved" block, you can indicate the address change in your configuration and specify the address change directly to Terraform. This allows Terraform to update the state to the new address without replacing it, ensuring that the resource is not destroyed and recreated unnecessarily.

The moved block in Terraform is a configuration feature that lets you refactor your Terraform code by specifying resource or module address changes directly within your configuration. 
This allows safe and non-destructive renaming, relocating, or restructuring of resources without the need for manual state adjustments or causing Terraform to destroy and recreate existing infrastructure.

#  Use modules in configuration

The Terraform Public Registry uses a shorthand syntax of NAMESPACE/NAME/PROVIDER in the source argument. 
For this VPC module, that's terraform-aws-modules/vpc/aws. It's best practice to specify a version constraint to ensure consistent deployments. Terraform automatically knows to fetch this from registry.terraform.io—you don't need to include the full URL. The registry.terraform.io domain is implied for public registry modules, and there is no registry argument for module blocks.


Questions : You want to use a VPC module you found on the Terraform Public Registry in your configuration. Which module block correctly references this registry module?
Answer:

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
}
Explanation
This choice correctly references the Terraform Public Registry module by specifying the source as terraform-aws-modules/vpc/aws and the version as 5.1.0 The source attribute should point to the module's location on the registry, and the version attribute ensures that a specific version of the module is used in the configuration.

# You open the terraform.tfstate file in a text editor to inspect it. What format is the file, and what type of information does it contain?
The terraform.tfstate file is stored as JSON in plaintext.
JSON format containing resource metadata, attributes, dependencies, and potentially sensitive values in plaintext.
You can view it with any text editor or use "terraform show" for a more readable format.
It contains the current state of your infrastructure, including resource attributes, metadata, resource dependencies, and provider configurations. Importantly, it can contain sensitive information like passwords, API keys, and private keys in plaintext. This is why the state file should be protected with appropriate permissions and never committed to version control systems.