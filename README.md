# atlantis-helm-deployment

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

This module deploys [Atlantis](https://www.runatlantis.io/) as helm release, provides a server side workflow definition and optionally creates required [cert-manager](https://github.com/goci-io/aws-cert-manager-helm) `Certificate` resource to use for HTTPS.

We extend the [runatlantis/atlantis](https://hub.docker.com/r/runatlantis/atlantis/) image by adding [`tfenv`](https://github.com/cloudposse/tfenv). 
By adding `tfenv` into the process you can access all environment variables as terraform variables.
The docker image is pushed to [gocidocker](https://hub.docker.com/u/gocidocker) on docker using [hub.docker.com]'s autobuild configuration.
Once a new release is created with a tag following the convention of `<major>.<minor>[.<patch>]-atlantis` the docker image build will be triggered

[![](https://images.microbadger.com/badges/version/gocidocker/atlantis.svg)](https://microbadger.com/images/gocidocker/atlantis "Get your own version badge on microbadger.com")

### Usage

For the latest version you can check the [releases](https://github.com/goci-io/atlantis-helm-deployment/releases) page. Use releases without the `-atlantis` suffix.

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

To setup a full github repository with atlantis (eg. if you provision initial build infrastructure seperatly) you can use our [github-repository](https://github.com/goci-io/github-repository) module.

For the AWS workflow the following environment variables are required:  
- `AWS_DEFAULT_REGION`  
- `TF_BUCKET`  

### Configuration

| Name | Description | Default |
|-----------------|----------------------------------------|---------|
| namespace | Company or organization prefix | - |
| stage | The stage the release is for | - |
| region | A custom region name to deploy the release into | - |
| name | The name of the helm release | `"atlantis"` |
| organization | Hosting organization (owner of the repositories) | - |
| repositories | List of repositories within the organization allowed to send webhooks to atlantis | `["*"]` |
| cluster_fqdn | Full qualified domain name to the root domain of the cluster | - |
| vc_host | Base url to the version control platform | `github.com` |
| vc_type | Type of the version control platform (valid values are `bitbucket`, `gitlab` and `github`) | `github` |
| environment_variables | Map of additional environment variables to attach to the atlantis pod | `{}` |
| k8s_namespace | The kubernetes namespace to deploy the helm release into | `"provisioning"` |
| pod_annotations | Additional map of annotations to add to the pod template | `{}` |
| helm_release_version | Version of helm chart to use for the deployment | `"3.10.1"` |
| apply_requirements | Requirements any pull request needs to fulfil before planning terraform diff | `["mergeable", "approved"]` |
| deploy_cert_manager_certificate | Deploys cert-manager certificate to use for HTTPS | `false` |
| cert_manager_issuer_name | "Name of an cert-manager Issuer in the same kubernetes namespace or cluster wide (depends on issuer_type) | `""` |
| cert_manager_issuer_type | Type of the Issuer specified in cert_manager_issuer_name. Either ClusterIssuer or Issuer | `"Issuer"` | 
| deploy_selfsigning_issuer | If there is no certificate issuer available we can deploy a selfsigning issuer to issue certificates | `false` |
| encrypted_user | Encrypted or plain username for the version control to use | `""` |
| encrypted_token | Encrypted or plain token for the version control to use | `""` |
| encrypted_secret | Encrypted or plain webhook secret to use | `""` |
| aws_region | AWS region atlantis will run it | - |
| lambda_encryption_function | Lambda function name used to decrypt secrets. You can use this [module](https://github.com/goci-io/aws-lambda-kms-encryption) for example | `""`|
| ssm_parameter_user | SSM Parameter name identifying the version control user | `""` |
| ssm_parameter_token | SSM Parameter name identifying the version control token | `""` |
| ssm_parameter_secret | SSM Parameter name identifying the webhook secret | `""` |

Either `encrypted_` variable values need to specify an encrypted string, used to decrypt during plan and apply or you will need to provide AWS SSM parameter names to specify the secrets. As a last rescue you can specify plain secrets in the `encrypted_` variables (which is not suggested). 

