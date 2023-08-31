# Demo: Simplify Application Authentication with AppSSO

This demo illustrates how developers can use AppSSO to easily embed
authentication into their apps from a centralized place.

- [RM/3KPs](#resounding-messages)
- [Setup Instructions: Internal APIs](#internal-api-demo)
- [Things To Point Out](#things-to-point-out)

## Resounding Messages


## Setting up the demo

### Prerequisites

- `ytt`
- An upstream identity provider, like Okta or Keycloak
- Tanzu CLI with the `apps` plugin installed
- `appsso.apps.tanzu.vmware.com` TAP package installed

> The stack provided in this repository sets all of this up for you.

### Instructions

1. Create an insecure `AuthServer`. This `AuthServer` will only grant tokens if
   a user provides the username and password provided to the `ytt` command
   below, which are `admin` and `supersecret` respectively:

   ```sh
   ytt -v auth_server_username=admin -v auth_server_password=supersecret \
    -v auth_server_privkey="$(cat /tmp/key.pem)" \
    -v auth_server_pubkey="$(cat /tmp/key.pub)" \
    -f ./demos/easy-app-authentication-with-appsso/conf/authserver.yaml |
    kubectl apply -f -
   ```

   Afterwards, wait for the `AuthServer` to come online:

   ```sh
   kubectl wait --for=condition=Ready authserver insecure-auth-server
   ```

## Things To Point Out

### Example 1

**Audience**: Example

- Point 1
- Point 2
- ...

## Troubleshooting

### Example 1

- Point 1
- Point 2
- ...
