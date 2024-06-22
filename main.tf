provider "aws" {
  shared_config_files = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_vpc" "jeffSA_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name="jeffSA_VPC"
    }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.jeffSA_vpc.id
}

resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.jeffSA_vpc.id
}

resource "aws_internet_gateway" "jeffSA_public_internet_gatewat" {
    vpc_id = aws_vpc.jeffSA_vpc.id
}

resource "aws_route_table" "jeffSA_public_subnet_route_table" {
  vpc_id = aws_vpc.jeffSA_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jeffSA_public_internet_gatewat.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.jeffSA_public_internet_gatewat.id
  }
}

resource "aws_route_table_association" "jeffSA_public_association" {
  route_table_id = aws_route_table.jeffSA_public_subnet_route_table.id
  subnet_id = aws_subnet.public_subnet.id
}


resource "aws_security_group" "web_server_sg" {
    vpc_id = aws_vpc.jeffSA_vpc.id
    ingress {
        description = "Allow HTTP trafic from internet"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  //Queremos que todo el tráfico entre
    }

    ingress {
        description = "Allow HTTPS trafic from internet"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  //Queremos que todo el tráfico entre
    }

    egress {
      description = "Allow all trafic"
      from_port = 0
      to_port = 0
      protocol = "-1"  //Esto significa que especificamos todas las opciones posibles,
                       //Todos los puertos posibles
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

    tags= {
      Name= "jeff security group"
    }
  
}


data "aws_ami" "ubuntu" {
  most_recent = "true"
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
  
}

resource "aws_instance" "ubuntu_instance_jeffSA" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true #En mi caso, con esta linea asociamos la ip pública que aws nos da a la instancia
}

resource "aws_network_interface" "jeffSA_network_interface" {
  subnet_id = aws_subnet.public_subnet.id //pasamos el id de la pública ya que es a la que deseamos que tenga acceso
  private_ips = ["10.0.1.10"]
  security_groups = [aws_security_group.web_server_sg.id]
}

resource "aws_eip" "jeffSA_elastic_ip" {
  associate_with_private_ip = tolist(aws_network_interface.jeffSA_network_interface.private_ips)[0]
  network_interface = aws_network_interface.jeffSA_network_interface.id
  instance = aws_instance.ubuntu_instance_jeffSA.id
  tags = {
    Name="jeffSA elastic ip"
  }
}

#De momento no logramos hacer que la instancia que hemos creado tenga la ip 10.0.1.10 faltan cosas

