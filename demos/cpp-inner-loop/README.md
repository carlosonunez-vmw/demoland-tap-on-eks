# Demo: Inner Loop Iteration with C++ on TAP

This demo demonstrates how TAP leverages buildpacks to make containerized
development iteration fast and tight with C++.

## Prerequisites

- Visual Studio Code
- `kubectl`
- AWS CLI.

## Resounding Messages

### Stop setting up local dev envs with App Live Update and Buildpacks

App Live Update works with Buildpacks to make testing your apps in a production-like environment
locally right from your IDE super easy.

### 3KP

- The Build Service eliminates the need for Dockerfiles.
- App Live Update eliminates the need for Docker Compose or similar abstractions
  for containerized dev envs.
- TAP's IDE plugins bring these features right to VSCode or IntelliJ.

### Running the demo

#### Beginning the Live Update

1. If needed, run `aws configure` and provide your AWS credentials when prompted.

> ✅  You don't need to do this if you're already logged into the
> AWS CLI.

> ✅ ## Skipping `aws configure`
>
> If you do not want to run `aws configure`, create a file
> called `$HOME/.aws/credentials` that looks like
> the file below:
>
> ```ini
> [default]
> aws_access_key_id = YOUR_ACCESS_KEY_ID
> aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
> aws_session_token = YOUR_AWS_STS_SESSION_TOKEN_IF_APPLICABLE
> ```

2. Run `98-update-eks-kubeconfig.sh` at the root of this repo to update your system's Kubeconfig with a
   context that's compatible with App Live Update.
3. Run `8-set-up-dev-namespace.sh` at the root of this repo to create the dev namespace for our demo app
   along with its "testing" pipeline.
3. Run `code $PWD/main.cpp`. This will open VSCode and bring you straight into
   the star of this show. Open a terminal underneath the code; we'll use it
   later.
4. Right click anywhere in the source code pane and select "App Live Update
   Start".

   A terminal should pop up beneath the source code pane and logs streaming from
   `tanzu apps workload apply` within it.
5. Go to the terminal that you opened. Run `telnet localhost 1234`. You should
   see `Welcome from the Tanzu Application Platform!` pop up.
