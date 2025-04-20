# Debian Repository of wstunnel

**This is no official repository of wstunnel but a third-party project.**
**If you got problems with wstunnel, contact the [author](https://github.com/erebe/wstunnel).**

The repository contains deb packages for the releases of [wstunnel](https://github.com/erebe/wstunnel).
To make use of the repository, follow the steps below.

# Prerequisites
* `curl`
* `sudo`

# Installation
* Import the signing key of the repository
```sh
sudo curl -fsSL https://seiferma.github.io/deb_wstunnel/pubkey.gpg -o /etc/apt/keyrings/wstunnel.asc
```

* Add the repository to the sources of apt
```sh
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/wstunnel.asc] https://seiferma.github.io/deb_wstunnel all main" | \
  sudo tee /etc/apt/sources.list.d/wstunnel.list > /dev/null
```

* Update the package cache and install `wstunnel`
```sh
apt-get update
apt-get install wstunnel
```