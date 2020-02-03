# atlantis-helm-deployment

This module deploys [Atlantis](https://www.runatlantis.io/) as helm release and provides a server side workflow definition.
We extend the [runatlantis/atlantis](https://hub.docker.com/r/runatlantis/atlantis/) image by adding [`tfenv`](https://github.com/cloudposse/tfenv). 
By adding `tfenv` into the process you can access all environment variables as terraform variables.

The docker image is pushed to [gocidocker](https://hub.docker.com/u/gocidocker) on docker using [hub.docker.com]'s autobuild configuration.
Once a new release is created with a tag following the convention of `<major>.<minor>[.<patch>]-atlantis` the docker image build will be triggered

You can view the latest docker release [here](https://hub.docker.com/r/gocidocker/atlantis/tags)

### Usage
```hcl
module "atlantis" {
  source        = "git::https://github.com/goci-io/atlantis-helm-deployment.git?ref=tags/<latest-version>"
  namespace     = "goci"
  stage         = "staging"
  region        = "eu1"
  aws_region    = "eu-central-1"
  cluster_fqdn  = "staging.eu1.goci.io"
  repositories  = [
    "aws.goci.io",
    "tools.goci.io",
    # ...
  ]

  environment_variables = {
    aws_default_region = "eu-central-1"
    tf_bucket          = "my-terraform-state-bucket-name"
  }
}
```

### Workflows

#### `default-aws` 

This is the default workflow for Terraform with an [AWS S3 backend](https://www.terraform.io/docs/backends/types/s3.html) and default AWS region set.
You will need to list your projects/modules within a seperate `atlantis.yaml` file in your repository. 

Example:

```yaml
version: 3
projects:
- dir: modules/cloudtrail
  name: cloudtrail
  workspace: staging
  autoplan:
    when_modified: ["modules/cloudtrail/*.tf", "*.tf*"]
    enabled: true
- dir: modules/cloudtrail
  name: cloudtrail
  workspace: prod
  autoplan:
    when_modified: ["modules/cloudtrail/*.tf", "*.tf*"]
    enabled: true
...
```

The project name will be used to generate the S3 key for the state file. It follows the convention of `${PROJECT_NAME}/terraform.tfstate`

For the AWS workflow the following environment variables are required:  
- `AWS_DEFAULT_REGION`  
- `TF_BUCKET`  

### Configuration


