resource "null_resource" "echo_command" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
  }
}

resource "null_resource" "ping_command" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }
  
  depends_on= [null_resource.echo_command]
}

resource "null_resource" "hello_command" {
  provisioner "local-exec" {
    command     = "print('Hello World!')"
    interpreter = ["python3", "-c"]
  }
  
}

resource "null_resource" "names_command" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Mark"
      NAME2 = "Paul"
      NAME3 = "Alex"
    }
  }
  
}

resource "aws_instance" "server" {
  ami           = "ami-024f768332f0"
  instance_type = "t3.micro"

  provisioner "local-exec" {
    command = "echo Hello from AWS Instance Creations!"
  }

}

resource "null_resource" "finish_command" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
  }
  
  depends_on= [null_resource.echo_command, null_resource.ping_command, null_resource.hello_command, null_resource.names_command, aws_instance.server]
}

