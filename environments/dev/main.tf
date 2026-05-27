# Calling S3 Module
module "tf_bucket" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
  tags        = var.tags
}

# Creates IAM resources for secure S3 access
module "iam" {
  source = "../../modules/iam"

  # IAM username
  iam_user = var.iam_user

  # Bucket ARN from S3 module output
  bucket_arn = module.tf_bucket.bucket_arn

  # Object ARN from S3 module output
  object_arn = module.tf_bucket.object_arn

  # Common tags
  tags = {
    Environment = "dev"
    Project     = "terraform-aws-infra"
  }
}

# Creating VPC module
module "vpc" {
  source = "../../modules/vpc"

  vpc-cidr            = var.vpc-cidr
  public-subnet-cidr  = var.public-subnet-cidr
  private-subnet-cidr = var.private-subnet-cidr
  azs                 = var.azs
  environment         = var.environment

  tags = var.vpc-tags
}

# Creating EC2 module
module "ec2" {
  # Path to EC2 Module
  source = "../../modules/ec2"

  # Ubuntu AMI ID
  ami_id = var.ami_id

  # EC2 Instance Type
  instance_type = var.instance_type

  # EC2 Instance Name
  ec2_name = var.ec2_name

  # Allowed ssh source IP
  allowed_ssh_cidr = var.allowed_ssh_cidr

  # Existing VPC module
  vpc_id = module.vpc.vpc_id

  # Deploy into 1st private subnet
  subnet_id = module.vpc.private_subnet_ids[0]

  # Existing S3 policy ARN from IAM module
  s3_policy_arn = module.iam.iam_policy_arn

  # Environment Name
  environment = var.environment

  # Tags
  tags = var.tags
}

# Creating RDS Module
# Deploys PostgreSQL RDS inside private subnets
module "rds" {

  # Path to RDS Module
  source = "../../modules/rds"

  # Database identifier
  db_identifier = var.db_identifier

  # Database name
  db_name = var.db_name

  # Database master username
  db_username = var.db_username

  # Database master password
  db_password = var.db_password

  # PostgreSQL engine version
  engine_version = var.engine_version

  # RDS instance type
  instance_class = var.instance_class

  # Storage allocation in GB
  allocated_storage = var.allocated_storage

  # Existing VPC ID
  vpc_id = module.vpc.vpc_id

  # Existing private subnet IDs
  private_subnet_ids = module.vpc.private_subnet_ids

  # Existing EC2 security group ID
  ec2_security_group_id = module.ec2.security_group_id

  # Environment name
  environment = var.environment

  # Common tags
  rds_tags = var.rds_tags
}