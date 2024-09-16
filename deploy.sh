#!/bin/sh

packer build images/templates
cd infrastructure
terraform init
terraform apply
