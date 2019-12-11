# Define o provider que será utilizado e os parâmetros necessários
# No caso, usaremos a AWS na region us-east-1 e as credenciais, como não foram
# explicitadas, irão ser obtidas de variáveis de ambiente ou do arquivo credentials do awscli
# (como default na maioria das bibliotecas da AWS)
provider "aws" {
  region = "us-east-1"
}

# Aqui estamos utilizando a funcionalidade de data-sources do Terraform, que traz
# informações de recursos já existentes. Aqui precisamos colocar os dados da sua AMI
# gerada através do Packer. Onde esta escrito "juan_aws_ami" é o nome da variável 
# que vamos chamar na criação da Ec2. Coloque o nome que preferir. 
# Em "values" coloque "AMI Name" da sua imagem AMI
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
  # ID do owner da AMI
  # Quando finalizar a criação da sua imagem AMI, vai ter uma coluna "Owner"
  # basta copiar e colar ele aqui
  owners = ["218913274184"]
}

# Criando um security-group para a instância
# Aqui você alterar o nome da variavel e colocar qual desejar, para isso basta alterar o "juan-sg"
# Em "name" coloque o nome que deseja dar ao seu security group
# Em "vpc_id" coloque o ID da VPC que a Ec2 irá pertencer, no meu caso e a minha default da AWS
resource "aws_security_group" "juan-sg" {
  name = "juan_security"
  description = "SG do Juan"
  vpc_id = "vpc-fc37ae86"

  # A regra a seguir libera saída e entrada para qualquer destino nos para HTTP/HTTPS e SSH
  # Lembrando que o correto nas portas "22" em cidr_blocks, é mai seguro definir o IP ou range
  # de IPs que deverão ter acesso SSH a instância.
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
# Onde esta "juan-ec2" pode colocar o nome que desejar
resource "aws_instance" "juan-ec2" {

  # Estamos referenciando o ID da AMI que foi setado no bloco anterior
  # Então altere o "juan_aws_ami" para o nome que colocou no bloco anterior
  ami = "${data.aws_ami.juan_aws_ami.id}"
  instance_type = "t2.micro"
  # Aqui você deve colocar o nome de alguma Key que tenha criada na AWS para poder acessar
  # a instância via SSH no futuro
  key_name = "desafiojuan"

  # Aqui estamos referenciando o ID do security-group criado nesse mesmo arquivo no bloco anterior
  # Então altere o "juan-sg" para o nome que colocou no bloco anterior
  # O Terraform cuidará de organizar as interdependências
  vpc_security_group_ids = [ "${aws_security_group.juan-sg.id}" ]
  # Aqui estamos definindo o tipo de storage usado. Não há necessidade de alterar
  root_block_device {
    volume_type = "gp2"
    volume_size = "30"
    delete_on_termination = true
  }
  # Aqui em "Name" você irá colocar o nome da sua instância.
  tags = {
    Name = "Name da sua Instância"
  }
}