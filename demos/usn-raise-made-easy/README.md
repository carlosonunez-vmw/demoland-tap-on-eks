# Demo: Organize your APIs with TAP

This demo outlines how TAP makes it easy to build and deploy RAISE-compliant
software through custom Cartographer Supply Chains.

Learn more about the RAISE framework
[here)(https://www.doncio.navy.mil/mobile/ContentView.aspx?ID=15943&TypeID=1).

> Creating custom supply chains is an advanced topic. However, the purpose
> of this demo is to illustrate the power that platform engineers inherit by
> being able to create these objects in a Kubernetes-native way.

- [RM/3KPs](#resounding-messages)
- [Setup Instructions: Internal APIs](#internal-api-demo)
- [Things To Point Out](#things-to-point-out)

## Resounding Messages

- Achieve and maintain a continuous Authority to Operate on every commit.
- Use the Supply Chain to incorporate your ISSMs into your path to production.
- Easily integrate with your team's security tools with `SourceScanner`s.

## Setting up the demo

### Prerequisites

- Harbor registry
- Tanzu CLI with the `apps` plugin installed
- `apis.apps.tanzu.vmware.com` TAP package installed

> The stack provided in this repository sets all of this up for you.

### Instructions

1. Apply the `ClusterTemplate`s

```sh
kubectl apply -f ./demos/usn-raise-made-easy/templates/
```

2. Apply the `SupplyChain`:

```sh
kubectl apply -f ./demos/usn-raise-made-easy/supply_chain.yaml
```

3. Apply the workload:

```sh
kubectl apply -f ./demos/usn-raise-made-easy/supply_chain.yaml
```

4. Visit the GUI and watch it fly!

## Things To Point Out

### Clean SBOMs with image scanning for free

The `SBOM` stage retrieves the SBOM of the image that TAP generated for the
example Java app in our workload...with some image scanning thrown in for free.
While this is accomplished with Trivy, you can change the image scanning tool as
needed.

## Troubleshooting

WIP.
