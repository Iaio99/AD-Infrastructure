#!/bin/sh

packer build images/templates
cd terraform
terraform init
terraform apply
