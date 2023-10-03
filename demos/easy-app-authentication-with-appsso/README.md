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

#### Creating a consumable AppSSO service

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

2. Create a `ClusterWorkloadRegistrationClass` that uses Services Toolkit to
   expose a service class that points to the `AuthServer`.

   ```sh
   kubectl apply -f
   ./demos/easy-app-authentication-with-appsso/conf/clusterworkloadregistrationclass.yaml
   ```

   Wait for it to become ready.

   ```sh
   kubectl wait --for=condition=Ready cwrc demo-class-sbx
   ```

3. Verify that the `AuthServer` has a service class associated with it.

    ```sh
    tanzu service class get demo-class-sbx
    ```

    This will dump a ton of information if it was successfully registered.

4. Now it's time to set up our authenticated app.

   Create the `ClassClaim` that's in `example-app/config`:

   ```sh
   ytt -v appNS=apps -v className=demo-class-sbx \
    -f ./demos/easy-app-authentication-with-appsso/example-app/config/ssoclassclaim.yaml |
    kubectl apply -f -
   ```

   Then wait for it to become ready.

   ```sh
   kubectl wait --for=condition=Ready -n apps \
    classclaim example-app
   ```

5. Generate a repo from the "Angular Frontend" accelerator:

   ```sh
   auth_server_url=$(kubectl get authserver insecure-auth-server \
    -o jsonpath='{.status.issuerURI}')
   ytt -v auth_server_url="$auth_server_url" \
     -v auth_server_label_key=env \
     -v auth_server_label_value=sandbox \
     -v namespace=apps \
     -f ./demos/easy-app-authentication-with-appsso/conf/accelerator-options.yaml |
     tanzu accelerator generate angular-frontend --options -
   ```

5. Deploy the workload. Wait for a `Delivery` to be stamped out.

  ```sh
  tanzu apps workload apply \
    -f ./demos/easy-app-authentication-with-appsso/example-app/config/workload.yaml \
    --local-path ./demos/easy-app-authentication-with-appsso/example-app \
    --namespace apps \
    --tail \
    --yes
  ```
## Things To Point Out

### The `AuthServer`

**Audience**: Security Engineers, Platform Engineers

The `AuthServer` is a web service that brokers creating JWTs for apps that use
it through `ClientRegistrations` and your upstream identity provider (IdP).

While TAP comes with an insecure test `AuthServer` to experiment with the
feature, it is compatible with any IdP that speaks OAuth2.

You can think of this as an interface for apps that want to secure some
endpoints with a login. As long as they can register themselves, they'll get
instant SSO for free.

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
