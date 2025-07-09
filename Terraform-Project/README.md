How Terraform configured to AWS EC2 instance?
> using IAM role(admin role) assigned to ec2 role 

Users in AWS for Human authorization to create different accounts while Roles is for non-human/ aws service to create different accounts.

one IAM role can be attached to multiple EC2 instances
But for one EC2 instance you can have only one IAM role.

+ means terraform creates a resources, check after terraform apply
- means terraform destroys a resources, check after terraform apply
~ means terraform updates a resources, check after terraform apply

-/+ means destorying & recreating (Ex- if you change ami)



# how do you configured AWS account with terraform to provison infra?
Created AWS Role, then Role has been assigned to EC2 instance.


# Variables in Terraform:
Supported DataType in Terraform
1. Numbers - No Need to enclose them in quotes
2. Boolean - No Need to enclose them in quotes
3. Strings - Need to enclose them in quotes (only double quotes)

Note- There is no concept of single quote in terraform.

# Variables are of 3 types:
1. Regular variable, a key with a single value.
2. List variable, a key with multiple values.
3. Map variable, a key with multiple key value pairs

'''
    var.sample    :use this only if this is not in between a set of strings
    ${var.sample} :use this if your variable has to be enclosed in a set of strings.
'''
# What is terraform.tfvars?
This is a file that holds the all the default values that needs to be used irrespective of the environment.
When you declare the variable values in this file, you dont have to explicitly mention this file as terraform picks "terraform.tfvars" file by default.
When you declare some value in dev.tfvars, qa.tfvars, prod.tfvars , then while running terraform commands, we need to mention that file.

terraform.tfvars can be used as common variable file across all environments.

vars.tf & terraform.auto.tfvars both files called as same.

# Variable files priority
cliVariables > ***.tfvars > terraform.tfvars > terraform.auto.tfvars


 Varibale filename One which you mention with command will have higher priority to use variable filename instead of taking from terraform.tfvars file.

How to run a tf command that has xyz.tfvars
 terraform init; terraform plan --var-file=dev.tfvars

if you want to prioritize variable file then use below in commands
terraform init; terraform plan --var-file=dev.tfvars -var environment=cli

If you need to access a variable then it should be empty variable

In terraform.tvars you give in key Value pair variables

DESTORY COMMAND - terraform destroy -auto approve




> Terraform Rule of Thumb
1. If you are using terraform, you need to align provison/update/maintain everything through terraform only.
2. Manual chnages should not be tolerated.
3. Even if someone does some changes manually on a terraform provisioned resource, we need to import in terraform code.

> What is a terraform drift?
1. When a resources is managed by terraform, if you wish to do the changes to that we only do it via tf code.
2. Doing changes directly from the console, will cause difference in what we have code on versus what is the current from.
3. This causes a tf drift.

if someone chnages in console & if you want to override what is there in code then run below command
terraform apply -auto-approve

If change in console is intended then, change the same in code & run terraform plan /apply

If you change/update in terraform code that cannot be called as  drift.

# Is a terraform apply disruptive?
1. Based on the type of change.
2. If you're changing tags or roles, it's happens without any downtime.
3. If you're changing instance_type (changes public IP as well), its disruptive, involves a downtime.

4. If you're changing the ami, then its destructive & then it creates new server & loose data of existing server.


# Attribute VS Arguments
Arguments - 
1. Properties needed to provision resource (like instance_type, disk_size
)
Attribute - 
2. Properties that comes up after the provsioning of resources (like private_ip, instance_id, arn)


if more than one values then enclose in [] this bracket.

# Outputs
1. Outputs Plays an imp role in terraform.
2. Outputs are used to print something.
3. They are also used to share the information between terraform modules.

# Naming Standards
1. Either use lowercase letters with - or _ only
2. follow camelCase.


# Important points to be considered - count/for_each
1. When you use count, you would be using count.index
count works with List.
2. If you are using for_each , you would  get each.key , each.value 



# When we learn anything , we keep on applying these principles.
...
    1. conditions
    2. variables
    3. functions
    4. loops
...

# Conditions 
condition ? true_val : false_val

If condition is true then the result is true_val. If condition is false then the result is false_val

# lookup Function
lookup(map, key, default)

lookup retrieves the value of a single element from a map, given its key. If the given key does not exist, the given default value is returned instead.

Example - 
> lookup({a="ay", b="bee"}, "a", "what?")
ay
> lookup({a="ay", b="bee"}, "c", "what?")
what?

# try Function
If the input/property itself not provided by you then script will not throw error while its takes a default value provided by you.



# Modules in Terraform 
1. They help in keeping the code DRY
2. And at the same time, code can be re-used

# Modules in Terraform are of 2 types
1. Terraform registry modules (readily available on Terraform portal)
2. Build Your own modules

# Module Sources in Terraform
1. Local Paths
2. Terraform Registry
3. Github
etc

# Terraform init is going to do 3 things
1. Initializes the backend
2. Downloads the needed plugins
3. Initializes the modules

# Modules
Modules are the containers for multiple resources that are used together.
Modules are the main way to package & reuse resource config with Terraform.

1. Root Modules : from where you run the Terraform comamnds
2. Child/Backend Module : The actual code

A module that has been called by another module is often referred to as a child module.

Passing information between 2 childs modules, cannot be done directly. It should be through root module.

"x-module ---> RootModule ----> y-Module "
Information from x-module to y-module would be done via rootModule in the form of outputs.

OUTPUT's play a very iportant role in passing the information between 2 modules.


# Terraform 
Terraform init is going to do these 3 changes
1. Initialization of the backend
2. Downloads the needed plugins
3. Initializes the modules

# 
alias "gp"=git pull
gp; terraform init; terraform plan
terraform fmt --recursive ; git add. ; git coomit -m "message" ; git push 

command to exeute with  variable filename - 
gp; terraform init; terraform plan --var-file=dev.tfvars -lock=false


# Datasources:
1. Datasource helps in querying the information that's already available

# Provisioners:
1. Local Provisioner : When you want some action to be performed on the machine you're running terraform, then we use local Provisioner.
2. Remote Provisioner : When you want some action to be performed on the provisioned/remote machine, then we use Remote Provisioner.
3. Connection Provisioner : To Perform some action on the top of newly provisioned machine, you need to enable a connection & that can be done via connection Provisioner.

** Notes **
    Provisioners should always be with in the resource.
    Provisioners are always create time provisioners, that means  they will only be executed on the resource during the creation time only. And when you run this for the second time, provisioners wont be executed.
    To make it run all the time , we can use triggers.
