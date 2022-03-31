resource "aws_vpc" "base_app" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.app}-${var.env}-vpc"
  }
}

resource "aws_subnet" "public_alpha" {
  vpc_id            = aws_vpc.base_app.id
  cidr_block        = var.public_alpha_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-alpha")

  tags = {
    Name = "${var.app}-${var.env}-public-alpha"
  }
}

resource "aws_subnet" "private_alpha" {
  vpc_id            = aws_vpc.base_app.id
  cidr_block        = var.private_alpha_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-alpha")

  tags = {
    Name = "${var.app}-${var.env}-private-alpha"
  }
}

resource "aws_subnet" "public_bravo" {
  vpc_id            = aws_vpc.base_app.id
  cidr_block        = var.public_bravo_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-bravo")

  tags = {
    Name = "${var.app}-${var.env}-public-bravo"
  }
}

resource "aws_subnet" "private_bravo" {
  vpc_id            = aws_vpc.base_app.id
  cidr_block        = var.private_bravo_cidr
  availability_zone = lookup(var.zones, "${var.aws_region}-bravo")

  tags = {
    Name = "${var.app}-${var.env}-private-bravo"
  }
}

resource "aws_internet_gateway" "base_app" {
  vpc_id = aws_vpc.base_app.id
  tags = {
    Name = "${var.app}-${var.env}-igw"
  }
}
resource "aws_eip" "elastic_ip_alpha" {
  vpc = true
}

resource "aws_eip" "elastic_ip_bravo" {
  vpc = true
}

resource "aws_route_table" "public_alpha" {
  vpc_id = aws_vpc.base_app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base_app.id
  }
  tags = {
    Name = "${var.app}-${var.env}-rt-public-alpha"
  }
}

resource "aws_route_table_association" "public_alpha" {
  subnet_id      = aws_subnet.public_alpha.id
  route_table_id = aws_route_table.public_alpha.id
}

resource "aws_route_table" "public_bravo" {
  vpc_id = aws_vpc.base_app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base_app.id
  }
  tags = {
    Name = "${var.app}-${var.env}-rt-public-bravo"
  }
}

resource "aws_route_table_association" "public_bravo" {
  subnet_id      = aws_subnet.public_bravo.id
  route_table_id = aws_route_table.public_bravo.id
}


# resource "aws_nat_gateway" "base-app-alpha-nat" {

#   subnet_id     = aws_subnet.public_alpha.id
#   allocation_id = aws_eip.elastic_ip_alpha.id
#   depends_on    = [aws_internet_gateway.base_app]
#   tags = {
#     Name = "${var.app}-${var.env}-alpha-nat"
#   }
# }

# resource "aws_nat_gateway" "base-app-bravo-nat" {

#   subnet_id     = aws_subnet.public_bravo.id
#   allocation_id = aws_eip.elastic_ip_bravo.id
#   depends_on    = [aws_internet_gateway.base_app]
#   tags = {
#     Name = "${var.app}-${var.env}-bravo-nat"
#   }
# }

# ## Route Tables ##
# resource "aws_route_table" "base-app-rt-private-alpha" {
#   vpc_id = aws_vpc.base_app.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.base-app-alpha-nat.id
#   }
#   tags = {
#     Name = "${var.app}-${var.env}-rt-private-alpha"
#   }
# }

# resource "aws_route_table_association" "base-app-rta-private-alpha" {
#   subnet_id      = aws_subnet.private_alpha.id
#   route_table_id = aws_route_table.base-app-rt-private-alpha.id
# }

# resource "aws_route_table" "base-app-rt-private-bravo" {
#   vpc_id = aws_vpc.base_app.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.base-app-bravo-nat.id
#   }
#   tags = {
#     Name = "${var.app}-${var.env}-rt-private-bravo"
#   }
# }

# resource "aws_route_table_association" "base-app-rta-private-bravo" {
#   subnet_id      = aws_subnet.private_bravo.id
#   route_table_id = aws_route_table.base-app-rt-private-bravo.id
# }
