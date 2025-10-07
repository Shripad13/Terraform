# Latest Version of Terraform - Version: 1.13.3

terraform -v

For Installation link - https://developer.hashicorp.com/terraform/install
'''
Commands - 
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

'''

## AWS IAM (Identity & Access Management)
1. This service in AWS helps humans to authenticate to AWS
2. Helps machines or Bots to authenticate to AWS
3. This defines authorization using ROLES.

### How can we use the keys & authenticate to cloud?
1. DOwnload the keys
2. Export keys on your linux server.
3. Thats it, you are suthenticated to AWS cloud & from that time, you can access your account on AWS cloud.
4. !!! Keep in mind , these are server where a bunch of people in your org has access to & anyone can see your ACCESS & SECRET key (which no one wants)
5. This way keys will be exposed throuhgh env variables on Server.
(if you run "env" command on server you will be able to see keys)
6. So we Create a ROLES to not to exposed any keys

# It Always goes with "Least Privilege Principl"e to achieve ZERO trust.

### How Authentication works in AWS (or in between AWS services without exposing credentials)
1. By Default one AWS service cannot authenticate to other AWS service.
2. In order to enable that authentication, we use something called as ROLES.
3. IAM Roles in AWS are to enable authentication between aws-services without need of exposing credentials.

If my ec2 instance want to authenticate & create k8s clusters & route53 records, what should I do?
1. Create AWS IAM role.
2. Assign the needed k8s & route53 permissions
3. Then assign that IAM role to the EC2 instance.
4. Now all the users connected to that instance can authenticate to the services.
5. This way , we dont have to download the credntials.

# How to create IAM Role & attach it for an EC2 instance?
1. IAM Roles are to enable authentication & authorization between services in AWS & services outside the AWS as well.
2. Create an IAM ROles saying that EC2 would like to do some actions.
3. Assign Admin access to the role.
4. Now attach this IAM Role to the EC2 instance & from them this EC2 instance is having admin access on the IAM account of AWS.
5. This way we dont have to download or expose the credentials.


# How Terraform configured to AWS EC2 instance?
> using IAM role(admin role) assigned to ec2 role 

Users in AWS for Human authorization to create different accounts while ROLES is for non-human/ enablig the authentication between aws services.


one IAM role can be attached to multiple EC2 instances
But for one EC2 instance you can have only one IAM role.

+ means terraform creates a resources, check after terraform apply
- means terraform destroys a resources, check after terraform apply
~ means terraform updates a resources, check after terraform apply

-/+ means destorying & recreating (Ex- if you change ami)

# Terraform need to apply inside folder not on any single file.




# Rule of Thumb when dealing with Terraform
1. When you are craeting infra , make sure you deal end-to-end with terraform only.
2. Manual changes on the console is 100 % NOT encouraged
3. If you do some changes on the infra provisioned or managed by terraform, terraform is going to wipe those manaul chnages when next run of terraform apply happens.

# When you run terraform apply, is terraform going to create or update or destory my infra?
1. It depends on the changes that you made on the code or on the infra
2. If you update the tags, it just replaces without any downtime or interruptions

# Downtime involves by updating below things -
1. If you just update the tags, it just replaces without any downtime or interruptions.

2. Instance type - t3 to t2
If you change the instance type, system goes down, updated the instance type & starts the instance.

3. ami - it will change of the boot disk, like properties change & you can verify by instance ID change
if you change the AMI, then its like destroying & Recreating the instance.


# Terraform commands

$ terraform init     (This will initializes the plugins needed for code)
$ terraform plan     (This will show what its going to chnage the infra based on the code vs what we have on the cloud)
$ terraform apply -auto-approve   (THis is going to apply changes shown on the plan, if applied immediately)


$ terraform init
$ terraform plan -out=myplan.out  (It will save the plan locally on myplan file)
$ terraform apply myplan.out    (apply from the myplan.out file only)

It will save the plan locally on myplan file
Always saving the plan file is better.





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


terraform init; terraform plan --var-file="dev.tfvars"; terraform apply --var-file="dev.tfvars" -auto-approve; 

1. Typically values that are common to all are placed on terraform.tfvars (because terraform bydefault picks variables from terraform.tfvars file only )
2. Values that are environment specific are placed on dev.tfvars or prod.tfvars

## What is *.auto.tfvars ?
1. Values that are declared in *.auto.tfvars file dont have to be mentioned while running tf commands & these will be picked by default.



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
Arguments - These are the inputs that helps in creating the infra with the properties of your choice.
1. Properties needed to provision resource (like instance_type, disk_size, ami, security_groups)

Attribute - These are the properties of the Infra that comes up post the creation of infra
2. Properties that comes up after the provisioning of resources (like private_ip, instance_id, arn, voulme_id)


if more than one values then enclose in [] this bracket.

# Outputs
1. Outputs Plays an imp role in terraform.
2. Outputs are used to print something.
3. They are also used to share the information between terraform modules.

# Naming Standards
1. Either use lowercase letters with - or _ only
2. follow camelCase.


# When we are dealing at scale, 'for-each' is going to make things handy and helps in efficient way to organize the code.

### for_each -
1. for_each accepts a map or set of strings , & creates an instance for each item in that map .
2. each instance has a distict infra object associated with it.& each is separately created/updated/destroyed when the config is applied.
3. map is nothing but a list of key-value pairs.



# Important points to be considered - count/for_each
1. When you use count, you would be using count.index
count works with List.
2. If you are using for_each , you would  get each.key , each.value 



# When we learn anything , we keep on applying these principles.
Always ensure these 4 pillars are covered.
...
    1. conditions
    2. variables
    3. functions
    4. loops
...

# Conditions 
condition ? true_val : false_val

If condition is true then the result is true_val. If condition is false then the result is false_val


# Functions in terraform  -
1. Function in terraform are spplied by hashicorp.
2. Each & every function has an action.
3. We cannot make our own functions we just consume them.

Ref - https://developer.hashicorp.com/terraform/language/functions


# Exception handling in Terraform -
1. If you dont declare a key & if you try to use it, it returns a value
2. we want to make sure , if values are not declared, it should pick a default value.
3. using 'lookup' function in terraform we can do efficiently when dealing map varibales.


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

## Typically when we are writing terraform, we need to write this in such a way where the code is so agnoistic to project & it can be used in any projects.

## Modules - 
A Modules is a collection of resources & config files in a directory that are used together. Modules are the primary  way to reuse & package resource config in terraform.

'''
> In Terraform , everything is a modules & the folders where you run the terraform commands is root module.

'''

# Modules in Terraform 
1. They help in keeping the code DRY
2. And at the same time, code can be re-used

# Modules in Terraform are of 2 types
1. Terraform registry modules (readily available on Terraform portal)
2. Build Your own modules (More controlled approach)

# Module Sources in Terraform
1. Local Paths
2. Terraform Registry
3. Github
etc

# Major Drawbacks of TF Registry Modules -
> You cannot use TF Registry Modules because it was created long back so when you use that time versions of TF modules or AWS services will be different.
> THese mdoules tightly coupled with the versions released at that time.
If AWS released some new version that time you should not use that registry module.



# Terraform init is going to do 3 things
1. Initializes the backend
2. Downloads the needed plugins
3. Initializes the modules

# Terraform plan
Plan is going to show what code is going to do w.r.t what is already there in the AWS account, based on this you are going to either apply or deny or tune it as per your requirement.


# Modules
Modules are the containers for multiple resources that are used together.
Modules are the main way to package & reuse resource config with Terraform.

> Why Modules Needed?
Clean code, reusability, scalability, testability, separation of concerns

1. Reusability - Avoid repeating the same code for different environments (dev/staging/prod).
2. Separation of Concerns - Split infrastructure into logical components: networking, compute, storage, monitoring, etc.
3. Scalability - Modules allow you to organize code cleanly, and scale it without chaos.
4. Testability and Maintenance - You can test and version individual child modules.
5. Consistency Across Environments - Use the same modules across dev, staging, and prod with different variables.


# 1. Root Modules : 
1. from where you run the Terraform comamnds is called as Root Modules 
2. The root module is made up of the resources defined in the main working directory's .tf files.
3. The entry point of a Terraform configuration (usually the main project folder). It may call child modules.  
4. The root module is everything in the main working directory where you run Terraform (terraform apply, terraform plan, etc.).
5. It includes files like main.tf, variables.tf, and outputs.tf.
6. This is the entry point to your infrastructure.
7. Think of it as the "main()" function in a programming language — it's where execution starts.


# 2. Child/Backend Module : The actual code
1. A module defined in a separate directory.
2. Child modules are modules that are called by the root module (or other modules).
3. These are often stored in a modules/ directory, or fetched from remote sources (GitHub, Terraform Registry, etc.).
4. Each child module is a self-contained unit for a specific task (e.g., VPC, EC2, RDS).


## Passing the info from root-module to backend module -
> Rule of the thumb, if you are using a variable in root module, that empty variable has to be declared in the child module, before you use & that where the data-transfer will happen. (thats way of receiving the data from the root module) 

'''
  1. Declare the variable in the root module.
  2. Define the value for that in the root module
  3. Declare an empty variable with the same name.
  Then use it in the backend module.

'''

## how to retrieve the info from backedn to root module?

 1. we have code in the backend module that creates EC2 & in the root module. we would like to print the IP-Address of the instance.
 2. this goes by outputs.

## Outputs -
 1. Outputs in terraform are not just for printing info
 2. they also play a role in transfering the info from one module to other module.

 ## Intro to Modules - 
 1) How to define modules.
 2) How to send info from root module to backend module.
 3) How to receive info from backend module to root module.

# This relation is very important while passing the info between the modules:
1. Inputs provided in *.tfvars
2. Declare associated empty variables in the root-Module (vars.tf)
3. Send the input to the module in the root module
4. Declare the empty variable in the backend module to get the value from root module.
5. Use the variable in the child module.


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
terraform fmt --recursive ; git add .; git commit -m "message" ; git push 

command to exeute with  variable filename - 
gp; terraform init; terraform plan --var-file=dev.tfvars -lock=false


# Datasources:
1. Datasource helps in EXTRACTING the information that's already available resources.
For each & every resource we have datasource available in the terraform documnetation of the intended resource.


# Provisioners:
1. Local Provisioner : When you want some action to be performed on the machine you're running terraform, then we use local Provisioner.
2. Remote Provisioner : When you want some action to be performed on the provisioned/remote machine, then we use Remote Provisioner.
3. Connection Provisioner : To Perform some action on the top of newly provisioned machine, you need to enable a connection & that can be done via connection Provisioner.

** Notes **
    Provisioners should always be with in the resource.
    Provisioners are always create time provisioners, that means  they will only be executed on the resource during the creation time only. And when you run this for the second time, provisioners wont be executed.
    To make it run all the time , we can use triggers.

# When to use Enclosed brackets?
> Trainings - Plural - use Square brackets [a,b,..]
> Training - singular - use in double quotes "a" 

