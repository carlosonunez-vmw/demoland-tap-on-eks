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

First, copy the `.env.example` in this folder to `.env`. Change anything that
says `change_me` in it.

Afterwards, every script starts with a number. Run them in order!

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
