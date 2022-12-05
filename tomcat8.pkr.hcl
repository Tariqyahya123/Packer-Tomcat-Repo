packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "TOMCAT8-V4"
  source_ami = "ami-"
  instance_type = "t2.micro"
  region        = ""
  ssh_username = "ubuntu"
  tags = {
      Name = "PACKER-U22.04-TOMCAT8"
  }

}

build {

 sources = [
  "source.amazon-ebs.ubuntu"
 ]

provisioner "file" {
  source = "./tomcat-service-file/tomcat8.service"
  destination = "/home/ubuntu/tomcat8.service"
}

provisioner "file" {
  source = "./snmpd-conf-file/snmpd.conf"
  destination = "/home/ubuntu/snmpd.conf"
}

provisioner "file" {
  source = "./filebeat-config/filebeat.yml"
  destination = "/home/ubuntu/filebeat.yml"
}


provisioner "file" {
  source = "./node-exporter/node_exporter.service.j2"
  destination = "/home/ubuntu/node_exporter.service.j2"
}



provisioner "file" {
  source = "./log-rotate/tomcat8"
  destination = "/home/ubuntu/tomcat8"
}



provisioner "shell" {
    inline = [    
#"sudo apt update",
"sudo apt install software-properties-common",
"sudo add-apt-repository --yes --update ppa:ansible/ansible",
"sudo apt-get update",
"sudo apt install ansible -y"]
}

  provisioner "ansible-local" {
    playbook_file   = "./tomcat-installation-playbooks/tomcat8-install.yaml"
  }

  provisioner "ansible-local" {
    playbook_file   = "./snmpd-conf-file/snmpd-install.yaml"
  }

  provisioner "ansible-local" {
    playbook_file   = "./filebeat-config/filebeat-installation.yaml"
  }

  provisioner "ansible-local" {
    playbook_file   = "./node-exporter/node-exporter-install.yaml"
  }


  provisioner "ansible-local" {
    playbook_file   = "./log-rotate/logrotate-config.yaml"
  }

provisioner "shell" {
    inline = ["rm -rf /home/ubuntu/*"]
}

}
