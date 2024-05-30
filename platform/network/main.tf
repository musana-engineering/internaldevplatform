locals {
  firewall_whitelist = ["8.29.228.126", "8.29.109.138"]
  location           = "westus3"

  tags = {
    provisioner = "terraform"
    location    = "westus3"
    project = "idp"
  }
}

// Virtual network
module "vnet" {
  source             = "../../modules/vnet"
  tags               = local.tags
  location           = local.location
  firewall_whitelist = local.firewall_whitelist

  virtual_networks = {
    "core" = {
      name          = "vnet-core-idp"
      address_space = ["10.141.0.0/16"]
      dns_servers   = ["168.63.129.16"]
    }
  }

  // Virtual network subnets
  virtual_network_subnets = {
    "aks" = {
      name                                          = "snet-aks-idp"
      virtual_network_name                          = "vnet-core-idp"
      address_prefixes                              = ["10.141.0.0/17"]
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    }

    "controlplane" = {
      name                                          = "snet-aks-cplane"
      virtual_network_name                          = "vnet-core-idp"
      address_prefixes                              = ["10.141.129.0/28"]
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    }
  }
}