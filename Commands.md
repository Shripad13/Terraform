# Daily Operations
1. Initialize and validate
terraform init
terraform fmt                 # Format code
terraform validate            # Check syntax

2. Planning and applying
terraform plan -out=tfplan    # Create execution plan
terraform apply tfplan        # Apply saved plan
terraform apply -auto-approve # Skip confirmation (use carefully!)

3. Specific resource targeting
terraform plan -target=aws_instance.web
terraform apply -target=aws_instance.web

4. Different environments
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars


# State Investigation
# Explore state
terraform state list
terraform state show aws_instance.web
terraform show                # Show entire state in readable format

# State management
terraform state mv aws_instance.old aws_instance.new
terraform state rm aws_instance.temporary
terraform import aws_instance.existing i-1234567890


# Work with multiple environments
terraform workspace list
terraform workspace new production
terraform workspace select production
terraform workspace show
Workspaces let you manage multiple states from the same code. Production and staging can share code but have separate states.

# Emergency Commands
1. Refresh state without making changes
terraform refresh

2. Unlock state if it gets stuck
terraform force-unlock LOCK_ID

3. Taint resource to force recreation
terraform taint aws_instance.web
terraform apply

4. Untaint if you changed your mind
terraform untaint aws_instance.web

5. Show dependency graph
terraform graph | dot -Tpng > graph.png

# Always Use Version Control
Initialize git repository
git init
echo “*.tfstate*” >> .gitignore
echo “*.tfvars” >> .gitignore
echo “.terraform/” >> .gitignore
git add .
git commit -m “Initial Terraform configuration”

Never commit:
State files (.tfstate)
Variable files with secrets (*.tfvars)
.terraform directory

