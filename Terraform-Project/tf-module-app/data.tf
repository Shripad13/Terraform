data "aws_route53_zone" "main" {
    name = "devsecopswithshri.site"
    private_zone = false
}


data "aws_ami" "main" {
    # most_recent = true  #Dont use it & it might cause this ec2 instance to be recreated all time

    owners = ["Add A/C ID"]


        name_regex = "b59-learning-ami-with-ansible"

}

data "vault_generic_secret" "ssh" {
    path = "expense-dev/ssh_cred"
}