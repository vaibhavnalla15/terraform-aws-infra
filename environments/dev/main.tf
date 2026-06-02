# Calling S3 Module
module "tf_bucket" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
  tags        = var.tags
}

# Calling IAM Module
module "iam" {
  source = "../../modules/iam"

  # IAM username
  iam_user = var.iam_user

  # Bucket ARN from S3 module output
  bucket_arn = module.tf_bucket.bucket_arn

  # Object ARN from S3 module output
  object_arn = module.tf_bucket.object_arn

  # Common tags
  tags = merge(
    var.tags,
    {
      Environment = local.environment
    }
  )
}

# Calling VPC module
module "vpc" {
  source = "../../modules/vpc"

  vpc-cidr            = var.vpc-cidr
  public-subnet-cidr  = var.public-subnet-cidr
  private-subnet-cidr = var.private-subnet-cidr
  azs                 = var.azs
  environment         = local.environment

  tags = merge(
    var.vpc-tags,
    {
      Environment = local.environment
    }
  )
}

# Calling EC2 module
module "ec2" {
  # Path to EC2 Module
  source = "../../modules/ec2"

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

  # Attaching SG to ALB
  alb_security_group_id = module.alb.alb_security_group_id

  # Environment Name
  environment = local.environment

  # Tags
  tags = merge(
    var.ec2_tags,
    {
      Environment = local.environment
    }
  )
}

# Calling RDS Module
# Deploys PostgreSQL RDS inside private subnets
# module "rds" {

#   # Path to RDS Module
#   source = "../../modules/rds"

#   # Database identifier
#   db_identifier = var.db_identifier

#   # Database name
#   db_name = var.db_name

#   # Database master username
#   db_username = var.db_username

#   # Database master password
#   db_password = var.db_password

#   # PostgreSQL engine version
#   engine_version = var.engine_version

#   # RDS instance type
#   instance_class = var.instance_class

#   # Storage allocation in GB
#   allocated_storage = var.allocated_storage

#   # Existing VPC ID
#   vpc_id = module.vpc.vpc_id

#   # Existing private subnet IDs
#   private_subnet_ids = module.vpc.private_subnet_ids

#   # Existing EC2 security group ID
#   ec2_security_group_id = module.ec2.security_group_id

#   # Environment name
#   environment = local.environment

#   # Common tags
#     tags = merge(
#   var.rds_tags,
#   {
#     Environment = local.environment
#   }
# )
# }

# Calling ALB Module
# Deploys public Application Load Balancer
module "alb" {

  # Path to alb module
  source = "../../modules/alb"

  # Existing VPC ID
  vpc_id = module.vpc.vpc_id

  # Public subnets for ALB
  public_subnet_ids = module.vpc.public_subnet_ids

  # Applicaion port
  target_port = 80

  # Environment name
  environment = local.environment

  # Common tags
  alb_tags = merge(
    var.tags,
    {
      Environment = local.environment
    }
  )
}

# Calling ASG Module
# Deploys Auto Scaling Group for application instances
module "asg" {

  # Path to ASG Module
  source = "../../modules/asg"

  # EC2 Instance Type
  instance_type = var.instance_type

  # Deploy Instances into private subnets
  private_subnet_ids = module.vpc.private_subnet_ids

  # Existing EC2 security group
  security_group_id = module.ec2.security_group_id

  # Existing IAM instance profile
  iam_instance_profile_name = module.ec2.instance_profile_name

  # Existing Target Group ARN
  target_group_arn = module.alb.target_group_arn

  # Auto scaling configuration
  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  # Environment name
  environment = local.environment

  # Common tags
  asg-tags = merge(
    var.tags,
    {
      Environment = local.environment
    }
  )
}

# Dynamic Secutrity Group module 
module "dynamic_sg" {

  # module path
  source = "../../modules/dynamic-sg"

  # SG Name
  security_group_name = "${local.environment}-dynamic-sg"

  # Existing VPC ID
  vpc_id = module.vpc.vpc_id

  # Dynamic ingress rules 
  ingress_rule = [
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"

      cidr_blocks = ["0.0.0.0/0"]

      description = "Allow SSH"
    },
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"

      cidr_blocks = ["0.0.0.0/0"]

      description = "Allow HTTP"
    },
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"

      cidr_blocks = ["0.0.0.0/0"]

      description = "Allow HTTPS"
    },
    {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"

      cidr_blocks = ["0.0.0.0/0"]

      description = "localhost"
    }
  ]

  # Common Tags
  tags = merge(
    var.tags,
    {
      Environment = local.environment
    }
  )
}
