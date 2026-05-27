# Security group for mysql RDS instance
resource "aws_security_group" "rds_sg" {

  # Security group name
  name = "${var.environment}-rds-sg"

  # Description for identification
  description = "Security group for mysql RDS"

  # Attach security group to existing VPC
  vpc_id = var.vpc_id

  # Allow mysql access ONLY from EC2 security group
  ingress {
    description = "Allow mysql access from EC2"

    from_port = 3306
    to_port   = 3306

    protocol = "tcp"

    # Allow access only from EC2 security group
    security_groups = [var.ec2_security_group_id]
  }

  # Allow outbound traffic
  egress {
    description = "Allow outbound traffic"

    from_port = 0
    to_port   = 0

    protocol = "-1" # semantically equivalent to all ports

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags for identification
  tags = merge(
    var.rds_tags,
    {
      Name = "${var.environment}-rds-sg"
    }
  )
}

# Creates DB subnet group for RDS private subnet placement
resource "aws_db_subnet_group" "db_subnet" {

  # Name of DB subnet group
  name = "${var.environment}-db-subnet-group"

  # Private subnets where RDS will be deployed
  subnet_ids = var.private_subnet_ids

  # Tags for identification
  tags = merge(
    var.rds_tags,
    {
      Name = "${var.environment}-db-subnet-group"
    }
  )
}

# Creates mysql RDS instance
resource "aws_db_instance" "mysql_db" {

  # Unique db identifier
  identifier = var.db_identifier

  # mysql engine
  engine = "mysql"

  # mysql engine version
  engine_version = var.engine_version

  # DB instance size
  instance_class = var.instance_class

  # Allocated storage in GB
  allocated_storage = var.allocated_storage

  # Initial DB name
  db_name = var.db_name

  # Master Usernmae
  username = var.db_username

  # Master Password
  password = var.db_password

  # Attach db to subnet group
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id

  # Attach RDS security group
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Disable public access
  publicly_accessible = false

  # Skip final snapshot for learning/demo
  skip_final_snapshot = true

  # Prevent accidental multi-AZ charges for now
  multi_az = false

  # Storage Type
  storage_type = "gp3"

  # Prevent automatic major upgrades
  auto_minor_version_upgrade = true

  storage_encrypted = false

  backup_retention_period = 0

  # Tags for Identification
  tags = merge(
    var.rds_tags,
    {
      Name = "${var.environment}-mysql-rds"
    }
  )
}

