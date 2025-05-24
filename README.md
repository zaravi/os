## Step 1: Install the official Fedora COSMIC Atomic ISO

1. [Download](https://fedoraproject.org/atomic-desktops/cosmic/download)
2. Flash ISO to a USB or boot with it in a Virtual Machine.
3. Setup and reboot.

## Step 2: Rebase to the unsigned variant to get the right signing keys.

```sh
rpm-ostree rebase ostree-unverified-registry:ghcr.io/zaravi/os:latest
```

```sh
systemctl reboot
```

## Step 3: Rebase to the signed variant.

```sh
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/zaravi/os:latest
```

```sh
systemctl reboot
```
