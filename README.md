# **Desafio Semana 3**

## Nessa automação, criaremos uma AMI via Packer e ligaremos ela via Terraform.

### **Para executar essa automação é necessário ter instalado as seguintes ferramentas e  configurações. Vamos a elas então.** 
<br>
 
> **User na Aws que contenha uma aws_access_key e aws_secret_key**<br> 
> **Ansible** <br>
> **Packer** <br>
> **Terraform** <br>
> **Aws CLI**<br>
> **Git**<br>
<p><br>

- ***Antes de instalar as ferramentas você precisar de se certificar que seu usuário que tenha sua access_key e secret_key tenha acesso de modificação na AWS Ec2.***


### **Abaixo segue link de como instalar** .

> **Ansible** <br>
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
> <br><br>
> **Packer** <br>
> https://www.iannoble.co.uk/how-to-install-packer/
> <br><br>
> **Terraform** <br>
> https://learn.hashicorp.com/terraform/getting-started/install.html
> <br><br>
> **AWS CLI**
> <br>
> https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux-mac.html
> <br><br>
> **Configurar AWS CLI** 
> <br>
> https://cloudacademy.com/blog/how-to-use-aws-cli/
> <br><br>
> **GIT**
> <br>
> https://git-scm.com/book/en/v2/Getting-Started-Installing-Git


Com as ferramentas instaladas, você já pode fazer o Download do repositório, para isso utilize os comandos:

```
Navega para alguma pasta que deseja receber o repositório da automação, por exemplo:

$ cd /home/user/Documents

Agora baixe o repositório atraés dos comandos:

$ git init
$ git clone https://github.com/jntoledo/desafio3.git

```

#### Após baixar o repositório vamos as configurações dos templates e executar os mesmos.

## **Configurando e executando o Packer**

Dentro do repositório que você baixou vamos alterar o arquivo **template_packer.json**. Nele você precisa aterar algumas linhas.

>***"ami_name":*** coloque aqui um nome para sua AMI. Conforme o exemplo que esta nessa linha.<br><br>
> ***"playbook_file:"*** coloque aqui o caminho do playbook que esta dentro da pasta "blog". No meu caso o playbook fica em: "/home/juan/Documents/desafio3/blog/blog.yml.<br>

Pronto, arquivo configurado. Agora já podemos executar o Packer. Utilize os seguintes comandos abaixo:

- **Importante: No comando abaixo "packer build" onde esta escrito abaixo "sua_access_key" e "sua_secret_key", coloque as keys do seu usuário que tenha permissão de alteração na AWS EC2.**

```
$ packer inspect template_packer.json
$ packer validate template_packer.json
$ packer build     -var 'aws_access_key=sua_access_key'     -var 'aws_secret_key=sua_secret_key'     template_packer.json
```
Após executar os comandos, basta aguardar a criação da AMI. Após finalizar a criação da mesma, vamos para a configuração e Execução do Terraform.

## **Configurando e executando o Terraform**
O arquivo que precisamos alterar para o Terraform é o **main_terraform.json**. Acesse o documento, e dentro dele tem os comentários do que deve e o que não deve ser alterado. Basta seguir as intruções dos comentários no documento.
<br>

Após alterar o documento **main_terraform.tf** e salvá-lo, vamos os comandos para executá-lo.
<br>

Siga esses comandos:

```
$ terraform init
$ terraform plan
$ terraform apply
```
**Quando iniciar o apply ele irá perguntar:**
> Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.<br>
>  **Enter a value**:

Basta colocar ***yes*** e ele irá executar o template.

Pronto ele já está criando sua Ec2 a partir de sua imagem AMI. Quando finalizar basta pegar o IP da sua instância e acessar ela via SSH através do comando:

> $ ssh centos@ip_sua_instancia -i sua_key.pem

Após acessar a instância, você precisa alterar a linha do **server name** no arquivo **blog-config.conf**.

Para acessar o arquivo basta digitar:

```
$ sudo su
$ vim /etc/nginx/conf.d/blog-config.conf
```
Dentro desse arquivo altere a linha:
> server_name 100.100.100.100;
> <BR>

Troque o "100.100.100.100" pelo IP da sua instância, ou seu DNS. Agora basta colocar seu IP ou seu DNS em algum navegador que você já cpnsiguirá acessar a página de Admin do seu blog.

### ***Pronto, executamos o Packer com Ansible criando toda a estrutura necessária para seu blog e salvando em uma AMI. Depois executamos o Terraform para iniciar essa AMI em uma instância Ec2 toda configurada para o seu Blog.***
