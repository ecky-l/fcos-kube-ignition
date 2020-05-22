# fcos-kube-ignition
An ignition file for installing Kubernetes on Fedora CoreOS

This ignition file provisions a [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/) instance and runs a post installation job to install the Kubernetes tools (kubeadm, kubelet, kubectl, crictl) on the machine. The result is a ready to run Fedora CoreOS instance, where `kubeadm init` or `kubeadm join` can immediately be run (this itself is not part of the ignition).

To achieve this, the ignition embeds the Kubernetes installation instructions found [here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) as a shell script into the ignition format for Fedora CoreOS, described [here](https://docs.fedoraproject.org/en-US/fedora-coreos/fcct-config/). It furthermore installs a oneshot systemd Unit to run the script after the initial provision has been done. The script installs some necessary tools via [rpm-ostree](https://rpm-ostree.readthedocs.io/en/latest/), does the necessary reboot and then downloads and installs the kubernetes tools at the second boot up.


# Build instructions

Review the ignition YAML and enter your SSH pub key in the passwd.users section. Substitute IP and hostname with suitable values. Build instructions itself can be found in build.sh, and it should be possible to run this script directly. Either podman or docker is needed to build the .ign file from the YAML.

For a bare metal installation, the resulting ignition must be served via http, as described [here](https://docs.fedoraproject.org/en-US/fedora-coreos/bare-metal/). The corresponding command to run a http server is the last step in the build instruction.

# State

The script works with Kubernetes 1.18.2 and might or might not be updated by the maintainer of this repository. Pull Requests are welcome.

There are some manual steps that should be further optimized, e.g. IP and hostname setup. This could be done by template substitution or some more advanced procedure.

# Alternatives

The ignition format is very limited and this file here pushes the purpose of ignition to its borders. As an alternative it should be considered to do just the basic provision and copy of SSH key with ignition, and use a tool like ansible to do advanced installation and configuration afterwards.

