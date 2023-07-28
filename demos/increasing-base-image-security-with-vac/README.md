# Demo: Securing your workflows with VMware Application Catalog

This demo used the Image Scanning feature within TAP to demonstrate the
simplicity that VAC provides in securing containers.

## Resounding Messages

### Easy Secured Containers

VAC provides secure and continuously-updated container images, Helm charts and
virtual machine images so that you don't have to.

### Three Key Points

- Container images provided by VAC have zero critical CVEs on delivery.
- Container images provided by VAC work similar to their open-source
  counterparts; no additional training required.
- Consuming images provided by VAC is as easy as any other container image, and
  it lives in your image registry.

## Setting up the demo

### Prerequisites

- Harbor registry
- Access to a VAC container registry
- `imgpkg`
- Tanzu CLI with the `apps` plugin installed

> The stack provided in this repository sets all of this up for you.

### Instructions

#### Provisioning

1. Provision a TAP cluster, if you don't already have one.

   [Click here](../../../README.md) to learn how to do that using the stack
   provided in this repo. This stack will also provision a Harbor registry for
   you at `harbor.$DOMAIN_NAME`.

2. Log into Harbor at `harbor.$DOMAIN_NAME` and create two projects with public
   access:

   - A project for storing your base image: `$PROJECT_NAME`, and
   - A project for storing your workload's images: `$WORKLOAD_PROJECT_NAME`

3. Sign into the Harbor registry: `docker login harbor.$DOMAIN_NAME --username admin --password supersecret`

4. Sign into the VAC-provided Harbor registry with `docker login`.

5. Copy the `nginx:1.25.1` image from the VAC-provided Harbor registry to your
   Harbor registry:

   ```sh
   imgpkg copy -i $VAC_REGISTRY/nginx:1.25.1 --to-repo harbor.$DOMAIN_NAME/$PROJECT_NAME/nginx
   ```

#### Dockerfiles

6. Open the Dockerfile in the `insecure` folder. Ensure that its base image is
   set to `nginx:1.25.1`

7. Open the Dockerfile in the `secure` folder. Ensure that its base image is set
   to `harbor.$DOMAIN_NAME/$PROJECT_NAME/nginx:1.25.1`.

#### Apply workloads

8. Apply the workloads:

   ```sh
   ./apply_workload.sh
   harbor.$DOMAIN_NAME/$WORKLOAD_PROJECT_NAME`
   ```

## Running the demo

1. Log into the Tanzu Application Platform.

> If you used the scripts in this directory to stage your TAP cluster,
> it will be located at `tap-gui.$DOMAIN_NAME`.

2. Click on the Security Analysis icon; the second to last icon on the
   left nav.

3. Click on "Does Not Violate Policy". Your two workloads should appear here.

4. Point out how many more vulns the insecure workload has over the secured one.
