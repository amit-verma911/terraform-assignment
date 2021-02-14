# Pre-requisites 


## NOTE : Please note this works with 0.11.14 version of terraform. 

```
https://releases.hashicorp.com/terraform/0.11.14/
```

Add your aws credentials using aws configure. You can have a look at https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

```
$ aws configure
AWS Access Key ID [None]: accesskey
AWS Secret Access Key [None]: secretkey
Default region name [None]: us-west-2
Default output format [None]:
```

Once you have added your credentials at `~/.aws/credentials ` and config at `~/.aws/config` we can start with terraforming. 


## Terraform starts here

Navigate to components folder and get into vpc folder. The only required variable for this component to work is cidr range, that has already been provided in the vars.tf (cidr "10.192.192.0/23") file. 

Please run this component using the below commands. 
-> terraform init to initialize terraform
-> terraform plan to see the plan of infra to be implemented 
-> terraform apply to apply the changes


Once this process is completed you can use the VPC id and subnet id as generated in outputs of file to be used in next component i.e. ec2_asg and replace the value of vpc_id, private_subnets_ids and public_subnets_ids. We would also need a kms key and need to have it's value under dev_key_id in vars file. 

After completing the above process follow the below steps : 

-> terraform init to initialize terraform
-> terraform plan to see the plan of infra to be implemented 
-> terraform apply to apply the changes


## Note : For destroy please use Terraform destroy



