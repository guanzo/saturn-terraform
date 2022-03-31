resource "aws_subnet" "database_private_alpha" {
  vpc_id            = aws_vpc.base_app.id
  cidr_block        = var.database_alpha_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-alpha")
  tags = {
    Name = "${var.app}-${var.env}-database-private-alpha",
  }
}

resource "aws_subnet" "database_private_bravo" {
  vpc_id            = aws_vpc.base_app.id
  cidr_block        = var.database_bravo_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-bravo")
  tags = {
    Name = "${var.app}-${var.env}-database-private-bravo",
  }
}

resource "aws_subnet" "database_private_charlie" {
  vpc_id            = aws_vpc.base_app.id
  cidr_block        = var.database_charlie_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-charlie")

  tags = {
    Name = "${var.app}-${var.env}-database-charlie"
  }
}

resource "aws_security_group" "database_security_group" {
  name        = "postgres_allow_private_subnets"
  description = "Allow traffic from alpha and bravo private subnets to postgres"
  vpc_id      = aws_vpc.base_app.id

  ingress {
    cidr_blocks = [
      aws_subnet.database_private_alpha.cidr_block,
      aws_subnet.database_private_bravo.cidr_block,
      aws_subnet.database_private_charlie.cidr_block,
      aws_subnet.private_alpha.cidr_block,
      aws_subnet.private_bravo.cidr_block,
      aws_subnet.public_alpha.cidr_block, # Allows bastion host to connect
    ]
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    description = "Alpha & Bravo CIDRs"
  }

  tags = {
      Name = "${var.app}-${var.env}-postgres-allow-private-subnets"
  }
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "${var.app}-${var.env}-aurora"
  subnet_ids = [
    aws_subnet.database_private_alpha.id,
    aws_subnet.database_private_bravo.id,
    aws_subnet.database_private_charlie.id
  ]

  tags = {
    Name = "${var.app}-${var.env}-aurora"
  }
}

resource "aws_security_group" "bastion_host" {
  name        = "bastion-host"
  description = "allow ssh from public places for database access"
  vpc_id      = aws_vpc.base_app.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app}-${var.env} allow ssh to bastion host"
  }
}

resource "aws_instance" "database_bastion_host" {
  ami           = "ami-0688ba7eeeeefe3cd"
  instance_type = "t3.micro"
  key_name      = "bastion-host-key-pair"
  subnet_id     = aws_subnet.public_alpha.id
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  tags = {
    Name = "${var.app}-${var.env}-database-bastion-host"
  }
}

resource "aws_eip" "bastion-host-eip" {
  instance = aws_instance.database_bastion_host.id
}

resource "aws_key_pair" "bastion-host-key-pair" {
  key_name = "bastion-host-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIFYsqvBv0n0xdwZafNdT7IRklzZyDZUQ8b+2MJuTqtQwpqUe1QE6iHfKIsDkPAxCV3LueuqTPiRnzEFtybI4oqGoBI+4Rql571D/xOgBrwfb6iJGLqi2PQm04SDF2EltjnJ053EFVCIuu9VznJZyKdUJys0kCE2OINKkr20TpD0s4McUynIDmGdXJA24XH8XSci06h32TzzL2cEuzRo4+r/03wLwKi88049vI1iadiMyolh6dYqPT5ChVXdsCh7zvrl0m5G6C1IcX5xezhwv5k31rFAQiz9x/LfQj6oMcKPumg+s0ykNHswnwGWvLPvkMDNue/IKZ02RjKEKgn7/8/wly5Jz8Y8//2c/wn6+F0vpUAx7s4XsHNcXTNI7QhcBq2t6Wt0Inzx1wY/p46EGh4EADn2ZU/FJvpY8ZtiVmdIrDIdmk0pjji8r/LnEdTOjsddiQOfKx1WNmlYw6LHnWTtgJRHXtk1ExkpqDglni89Dmi2b9WzVdfXKb7/Sd61m/8BZSn4BbMimKNVqZiP+q9sLXdJPAK5yO3MNz+w1EUC4gvL2JX5GUBkT65Pchycop7uv+7WeIbryD7yZn1s3jl/Iy6dhRXb+CnEuuzkPPog1vx1eqgccJz34Xd03hju+79YpnfC9hC5755Zt3JMQUpm1k17DTDMURX3bsW3U0Fw=="
}
