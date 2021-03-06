variable "organization" {
  type        = string
  description = "The version control organization owner (eg: goci-io)"
}

variable "repositories" {
  type        = list(string)
  default     = ["*"]
  description = "List of repositories. Defaults to all repositories within the organization"
}

variable "namespace" {
  type        = string
  description = "Organization or company prefix"
}

variable "stage" {
  type        = string
  description = "Stage for which to deploy the release"
}

variable "region" {
  type        = string
  description = "Custom region name"
}

variable "k8s_namespace" {
  type        = string
  default     = "provisioning"
  description = "The kubernetes namespace to deploy the release into"
}

variable "name" {
  type        = string
  default     = "atlantis"
  description = "Deployment name of the helm release"
}

variable "attributes" {
  type        = list
  default     = []
  description = "Additional attributes (e.g. `eu1`)"
}

variable "pod_annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to be added to the pod template"
}

variable "helm_release_version" {
  type        = string
  default     = "3.12.2"
  description = "Version of the helm release to deploy"
}

variable "helm_values_root" {
  type        = string
  default     = "."
  description = "Path to the directory containing values.yaml for helm to overwrite any defaults"
}

variable "aws_region" {
  type        = string
  description = "AWS Region to deploy atlantis to"
}

variable "vc_host" {
  type        = string
  default     = "github.com"
  description = "Host to the version control system (github, gitlab, bitbucket)"
}

variable "vc_type" {
  type        = string
  default     = "github"
  description = "The version control system platform to use. Valid values are bitbucket, github and gitlab"
}

variable "apply_requirements" {
  type        = list(string)
  default     = ["approved", "mergeable"]
  description = "Requirements before running terraform apply"
}

variable "create_server_role" {
  type        = bool
  default     = false
  description = "Creates an IAM Role for the Atlantis Server"
}

variable "server_role_arn" {
  type        = string
  default     = ""
  description = "ARN of an existing Role to use for the Atlantis Server"
}

variable "server_role_external_id" {
  type        = string
  default     = ""
  description = "External-ID to be used to assume the role specified in server_role_arn"
}

variable "server_role_policy_statements" {
  type        = list(any)
  default     = []
  description = "Additional statements of effect, actions and ressources to grant Atlantis Server"
}

variable "server_role_policy_json" {
  type        = string
  default     = ""
  description = "Additional plain JSON Policy to attach to the Server Role. Use the Result of aws_iam_policy_document.json"
}

variable "server_role_trusted_arns" {
  type        = list(string)
  default     = []
  description = "AWS Resource ARNs allowed to assume the created Role (takes effect when create_server_role is set to true)"
}

variable "server_role_name_override" {
  type        = string
  default     = ""
  description = "Overrides the IAM role name to use for Atlantis"
}

variable "configure_kiam" {
  type        = bool
  default     = false
  description = "Adds Kiam Annotations to the Pod using the Role created or specified in server_role_arn"
}

variable "lambda_encryption_function" {
  type        = string
  default     = ""
  description = "Name of a lambda function to decrypt the values"
}

variable "encrypted_user" {
  type        = string
  default     = ""
  description = "Encrypted username. Lambda function specified in lambda_encryption_function is used to decrypt"
}

variable "encrypted_token" {
  type        = string
  default     = ""
  description = "Encrypted username. Lambda function specified in lambda_encryption_function is used to decrypt"
}

variable "encrypted_secret" {
  type        = string
  default     = ""
  description = "Encrypted webhook secret. If not set a random secret will be generated. Lambda function specified in lambda_encryption_function is used to decrypt"
}

variable "ssm_parameter_secret" {
  type        = string
  default     = ""
  description = "SSM Parameter name to get the webhook secret"
}

variable "ssm_parameter_token" {
  type        = string
  default     = ""
  description = "SSM Parameter name to get the version control access token"
}

variable "ssm_parameter_user" {
  type        = string
  default     = ""
  description = "SSM Parameter name to get the version control username"
}

variable "cluster_fqdn" {
  type        = string
  description = "The full qualified domain name for the cluster root domain (basically the ingress root dns name)"
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "Additional environment variables to add to the pod template"
}

variable "enable_tls" {
  type        = bool
  default     = false
  description = "Configures the TLS configuration options for the ingress pointing to secret called <name>-tls. Automatically enabled when configure_cert_manager is set to true"
}

variable "configure_cert_manager" {
  type        = bool
  default     = false
  description = "Adds required annotations to use cert-manager"
}

variable "cert_manager_issuer_name" {
  type        = string
  default     = ""
  description = "The Issuer to use to create the certificate with cert-manager"
}

variable "cert_manager_cluster_issuer_name" {
  type        = string
  default     = ""
  description = "The ClusterIssuer to use to create the certificate with cert-manager. Conflicts with cert_manager_issuer_name"
}

variable "configure_nginx" {
  type        = bool
  default     = false
  description = "Creates nginx annotations on the ingress with SSL passthrough enabled"
}

variable "ingress_class" {
  type        = string
  default     = ""
  description = "If set the ingress will be annotated with kubernetes.io/ingress.class"
}

variable "ingress_annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations for the ingress. Eg if none of the existing preconfiguration suits your needs. You can also use values.yaml to override any configuration."
}

variable "terraform_environment_variables" {
  type        = map(string)
  default     = {}
  description = "Additional terraform variables available as terraform variable (TF_VAR prefix)"
}

variable "exposed_atlantis_environment_variables" {
  type        = map(string)
  default     = {}
  description = "Variables to expose to Terraform environment from Atlantis pod environment itself"
}
