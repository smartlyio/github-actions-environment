# github-actions-environment

Packer template and scripts to build AWS-based Github Actions runners

The packer build depends on the having credentials for an AWS user to
create and run EC2 machines, and create AMIs from them. These
credentials should be configured in an AWS profile,
e.g. `packer-github-actions`.

## AWS configuration assumptions

- One or more subnets are available with the tag `PackerBuild: true`,
  and the subnets allow associating a public IP address.

## Running the packer build

To run packer manually, run the following:

```
$ export AWS_PROFILE=packer-github-actions
$ packer build github-actions-image.json
```

This will run the build in EC2, and then create a new AMI from the
build VM, which can be used from the github-actions runner terraform
module.
