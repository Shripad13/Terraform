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


# Terraform Command -
terraform init; terraform plan; terraform apply -auto-approve


## Interview Questons -
1. How are you managing the state file in terraform?
manging on top of AWS S3 Bucket

2. Why Terraform, as you're already on AWS, why are you not using CloudFormation?
We are also using some 3rd party products like conflunce, mongoDB
Also we have planned to use Multi-Cloud Approach
With CloudFormation only AWS specific services can be used.

3. if you're tf state is corrupted, what would you do?
Always enable versioning on s3 bucket & simply go back to previous verison



4. What is the TF drift & how do you handle it.?
Whenever Infra is created by TF is disyurbed by human
Whenver drift comes up & make sure that change is intended or not 
then go & try to run & accept the drift.

5. What is tf.state & tf.state.backup

6. How to delete tf cache?
 remove the cache (rm -rf .terraform) in local

7. how do you list the object that are created by tf when you are in repo?
terraform init
terraform state list 

terraform state rm <obejct_name>   ------ for eliminate the object from satate

8. What is a provisioner & null resource in tf?
Provisoner - if want to execute something on remote instance 
Provisoners always executed on the resource
null resource - 

9. WHy provisioners are reffered as create time provisioners?
Provisioners will only run during creation of resources
from 2nd time it will refreshes  

10. how can we make sure that provisioners are executed all the time you run tf plan/apply ?
We have triggers - By mentioning this provisioners are executed all the time 

11. How can we ensure that tf wont destory resources accidentally ?
** Terraform LifeCycle
* create_before_destory ----> before destorying it will create bcoz avoiding downtime
This is useful for resources that cannot be updated in-place or where downtime must be minimized during updates 
* prevent_destroy = true
If you attempt to destroy a resource with prevent_destroy = true, Terraform will return an error, safeguarding critical infrastructure like production databases
* ignore_changes ---> This argument takes a list of resource attributes that Terraform should ignore when determining if a change has occurred. 


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
AWS

S3 bucket object lock

IAM deny deletes

Termination protection for EC2:

resource "aws_instance" "prod" {
  instance_type          = "t3.micro"
  ami                    = "ami-123"

  disable_api_termination = true
}

12. how do you integarte AWS S3 with DynamoDB for state locking mechanism?