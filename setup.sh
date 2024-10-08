#!/bin/sh

packer build images/templates
cd terraform
terraform destroy
terraform init
terraform apply
cd ../ansible
ansible-playbook site.yml
cd ..
