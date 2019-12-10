# Define o provider que será utilizado e os parâmetros necessários
# No caso, usaremos a AWS na region us-east-1 e as credenciais, como não foram
# explicitadas, irão ser obtidas de variáveis de ambiente ou do arquivo credentials do awscli
# (como default na maioria das bibliotecas da AWS)
provider "aws" {
  region = "us-east-1"
}

# Aqui estamos utilizando a funcionalidade de data-sources do Terraform, que traz
# informações de recursos já existentes. Nesse caso, estamos obtendo informações
# da imagem (AMI) mais recente do CoreOS stable da AWS
data "aws_ami" "juan_aws_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["juan_packer_ansible"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  # ID do owner da AMI no AWS AMI Marketplace
  # (colocado hardcoded aqui para facilitar este exemplo)
  owners = ["218913274184"]
}

# Criando um security-group para a instância
resource "aws_security_group" "juan-sg" {
  name = "juan_security"
  description = "SG do Juan"
  vpc_id = "vpc-fc37ae86"

  # A regra a seguir libera saída para qualquer destino em qualquer protocolo
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port       = "22"
      to_port         = "22"
      protocol        = "tcp"
      cidr_blocks = [ "177.70.100.10/32" ]
  }

}


# Aqui, estamos definindo uma instância no EC2
resource "aws_instance" "juan-ec2" {

  # Estamos referenciando o ID da AMI que foi setado no bloco anterior
  ami = "${data.aws_ami.juan_aws_ami.id}"
  instance_type = "t2.micro"
  key_name = "desafiojuan"
  #subnet_id = "subnet-123456"

  # Estamos referenciando o ID do security-group criado nesse mesmo arquivo
  # O Terraform cuidará de organizar as interdependências
  vpc_security_group_ids = [ "${aws_security_group.juan-sg.id}" ]

  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = true
  }

  tags = {
    Name = "Nome da sua Intância"
  }
}