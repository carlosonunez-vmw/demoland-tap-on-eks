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
   openssl genrsa -out /tmp/key.pem 3072 &&
    openssl rsa -in /tmp/key.pem -pubout -out /tmp/key.pub &&
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

2. Register a new client of that `AuthServer`. This way, we can obtain a client
   ID and a client secret to use for logging in via this `AuthServer`.

   You can think of this as similar to creating a new "app" for a Google Cloud
   API or an app to use within Okta.

   ```sh
   ytt -v domain=$YOUR_TAP_CLUSTER_DOMAIN \
    -f ./demos/easy-app-authentication-with-appsso/conf/client_registration.yaml |
    kubectl apply -f -
   ```

   Wait for the `ClientRegistration` to become `Ready`:

   ```sh
   kubectl get clientregistrations -n apps
   ```

3. Create an instance of `oauth-proxy` in the `default` namespace.

   This will provide a OAuth client that brokers the OAuth2 login flow on your
   application's behalf.

   ```sh
   ytt -v domain=$YOUR_TAP_CLUSTER_DOMAIN \
    -f ./demos/easy-app-authentication-with-appsso/example-app/dependencies/oauth_proxy.yaml  |
    kubectl apply -f -
   ```

   Wait for the `oauth-proxy-for-example-app` `Deployment` to become fully ready
   (i.e. `1/1` replicas available)

   ```sh
   kubectl get deployment oauth-proxy-for-example-app
   ```

   This will also generate an `HTTPProxy` resource that responds to the URI
   `http://oauth-proxy-for-example-app.$YOUR_TAP_CLUSTER_DOMAIN`.

   This URI is externally-accessible. 

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
