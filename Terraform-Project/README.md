How Terraform configured to AWS EC2 instance?
> using IAM role(admin role) assigned to ec2 role 

how do you configured AWS account with terraform to provison infra?

# Variables in Terraform:
Supported DataType in Terraform
1. Numbers - No Need to enclose them in quotes
2. Boolean - No Need to enclose them in quotes
3. Strings - Need to enclose them in quotes (only double quotes)

Note- There is no concept of single quote in terraform.

# Variables of 3 types:
1. Regular variable, a key with a single value.
2. List variable, a key with multiple values.
3. Map variable, a key with multiple key value pairs

# What is terraform.tfvars?
This is a file taht holds the all the default values that needs to be used irrespective of the environment.
When you declare the variable values in this file, you dont have to explicitly mention this file as terraform picks "terraform.tfvars" by default.
When you declare some value in dev.tfvars, qa.tfvars, prod.tfvars , then while running terraform commands, we need to mention that file.

# Variable files priority
cliVariables > ***.tfvars > terraform.tfvars > terraform.auto.tfvars

How to run a tf command that has xyz.tfvars
 terraform init; terraform plan --var-file=dev.tfvars

if you want to prioritize variable file then use below in commands
terraform init; terraform plan --var-file=dev.tfvars -var environment=cli

If you need to access a variable then it should be empty variable

IN terraform.tvars you give in key Value pair variables

DEstroy Command - terraform destroy -auto approve

##Important points to be considered.
1. When you use count, you would be using count.index
2. If youre using for_each , you would  get each.key , each.value 

# When we learn anything , we keep on applying these principles.
...
    1. conditions
    2. variables
    3. functions
    4. loops
...

# Modules in Terraform 
1. They help in keeping the code DRY
2. And at the same time, code can be re-used

# Modules in Terraform are of 2 types
1. Terraform registry modules (readily available on Terraform portal)
2. Build Your own modules

# Terraform init is going to do these 3 changes
1. Initialization of the backend
2. Downloads the needed plugins
3. Initializes the modules

# 
terraform fmt --recursive ; git add. ; git coomit -m "message" ; git push 