param location string
param loginServer string
param containerBuildName string
param identityName string
param ghRepository string
param ghPersonalToken string
param keyVaultUri string
param aciName string
param aciSku string
param aciGroupName string
param ghRunnerName string
var aciImage = '${loginServer}/${containerBuildName}'

resource managed_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: identityName
}

resource aro_config_container 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: aciName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managed_identity.id}': {
      }
    }
  }
  properties: {
    sku: aciSku
    containers: [
      {
        name: aciGroupName
        properties: {
          image: aciImage
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
          environmentVariables: [
            {
                name: 'REPOSITORY'
                value: ghRepository
            }
            {
                name: 'RUNNER_NAME'
                value: ghRunnerName
            }
            {
                name: 'PAT_GITHUB'
                secureValue: ghPersonalToken
            }
            {
              name: 'KV_URI'
              secureValue: keyVaultUri
            }
          ]
          resources: {
            requests: {
              memoryInGB: 1
              cpu: 1
            }
          }
        }
      }
    ]
    initContainers: []
    imageRegistryCredentials: [
      {
        server: loginServer
        identity: managed_identity.id
      }
    ]
    restartPolicy: 'OnFailure'
    ipAddress: {
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
      type: 'Public'
    }
    osType: 'Linux'
  }
}

output containerName string = aro_config_container.name
