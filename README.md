# github-actions-environment

Packer template snippets to build AWS-based Github Actions runners
from the upstream Github virtual-environments definitions at
https://github.com/actions/virtual-environments

The packer build depends on the having credentials for an AWS user to
create and run EC2 machines, and create AMIs from them. These
credentials should be configured in an AWS profile,
e.g. `packer-github-actions`.


## Implementation

The `build.sh` script generates a new packer template from Github's
upstream ubuntu 18.04 template, replacing the `builders` and
`variables` with appropriate sets for AWS. Azure-specific details are
removed from the buildscripts (e.g. configuring `waagent`), and then
the builder is executed.

## AWS configuration assumptions

- One or more subnets are available with the tag `PackerBuild: true`,
  and the subnets allow associating a public IP address.

## Running the packer build

To run the packer build, run the following:

```
$ ./build.sh <aws-profile-name>
```

This will run the build in EC2, and then create a new AMI from the
build VM, which can be used from the github-actions runner terraform
module.
