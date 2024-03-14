param location string
param vnetName string
param vnetCidr string
param controlPlaneSubnetCidr string
param computeSubnetCidr string
param tags object
param controlPlaneSubnetName string
param computeSubnetName string

resource cluster_vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCidr
      ]
    }
    subnets: [
      {
        name: controlPlaneSubnetName
        properties: {
          addressPrefix: controlPlaneSubnetCidr
          serviceEndpoints: [ { service: 'Microsoft.ContainerRegistry' } ]
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
      {
        name: computeSubnetName
        properties: {
          addressPrefix: computeSubnetCidr
          serviceEndpoints: [ { service: 'Microsoft.ContainerRegistry' } ]
        }
      }
    ]
  }
}

output vnetName string = vnetName
