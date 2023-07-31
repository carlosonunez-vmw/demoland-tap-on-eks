# TAP on AWS EKS!

This repo documents how to install TAP on AWS EKS through a series of scripts.

> 💸 **WARNING**: This will cost you money!
>
> These scripts deploy AWS EKS into a VPC called `tkg-tap-land`.
>
> While the EKS node group bound to that EKS control plane uses cost-efficient
> `t3a.large` nodes with spot prices, it will deploy three of them (with an option to surge to
> five).
>
> EBS volumes, an ELB and several Route53 records will be created as well.
>
> Free Tier will cover some of this, but not all.

## Caveats

- I wrote this while learning TAP. Don't use this for anything production.
- This will probably light your computer on fire!
- Probably not suitable for POCs either, unless it's something super quick.

## How to Use

### Prerequisites


#### For everyone

- Docker
- [`yq`](https://github.com/mikefarah/yq)
- An AWS Route53 hosted zone (click
  [here](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html)
  to learn how to create one.)

#### For contributors

- [`sops`](https://github.com/getsops/sops) (optional)
- [`gpg2`]

### Instructions

First, copy `config.example.yaml` to `config.yaml` and change all of the blanks
to real values.

Afterwards, log into AWS and ensure that the following values are set
in your environment:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `AWS_SESSION_TOKEN` (if using an STS-generated credential)

Afterwards, every script starts with a number. Run them in order!

> ## Encrypting your config
>
> If you are contributing and want to create a pull request, or if you
> are more security-conscious and don't want your passwords and such
> in plain-text, encrypt your config file with sops, like this:
>
> ```sh
> sops -p CONFIG_FILE_PGP_FINGERPRINT config.yaml > config.enc.yaml
> ```
>
> Note that changes to `config.enc.yaml` are not accepted at this time.

## Questions

### TAP installs cert-manager and Contour, but they are installed before TAP

This was done to resolve this cyclic dependency:

- TAP requires Harbor when installing from offline images (the recommended
  approach)
- Harbor requires cert-manager and Contour (or any ingress controller) to be
  present
- but TAP installs Cert Manager and Contour

To work around this, we specifically exclude those two packages from the TAP
install in our `values.yaml` values file.
## References

- [Carlos's TAP on Kind
  Tracker](https://www.pivotaltracker.com/n/projects/2626297)
- [The Original TAP Activation Guide
  Tracker](https://www.pivotaltracker.com/n/projects/2586967)
