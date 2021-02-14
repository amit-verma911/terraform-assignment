# VPC module

This component creates a SS VPC with public, private & shared subnets, NAT gateways, NACLs, an internal Route53 zone and a Virtual Private Gateway.


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | Shared Solution Name | - | yes |
| env | Environment Name | - | yes |
| cidr | CIDR range to use for the VPC. This will be automatically split into subnet CIDRS. | - | yes |
| az_count | Number of availability zones to use, the AZs will be retrieved automatically for the current region. | - | yes |
| naming | A map from count index to A,B,C,D etc. | `<list>` | no |
| whitelist | A list of IPs or IP ranges (in CIDR notation) that can access the public subnets | `<list>` | no |
| trusted_networks | A list of IP networks that the private subnets can communicate with | `<list>` | no |
| vgw_tags | Transit VPC Tags for the VGW | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| shared_subnets |  |
| private_subnets |  |
| public_subnets |  |
| shared_subnet_cidrs |  |
| private_subnet_cidrs |  |
| public_subnet_cidrs |  |
| vpc_id |  |
| public_route_table_id |  |
| private_route_table_id |  |
| shared_route_table_id |  |
| default_security_group_id |  |

