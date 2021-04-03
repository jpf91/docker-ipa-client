# [jpf91/ipa-client](https://github.com/jpf91/docker-ipa-client)

This image provides an IPA client image based on the latest fedora release.

## Supported Architectures

Currently only `x86_64` images are being built, allthough the `Dockerfile` is not architecture dependent.

## Usage

Here are some instructions and snippets to help you get started creating a container.

### Initial configuration

#### IPA options

Before starting the container the first time, you need to setup a file with options to be passed to ipa-client-install:

Here's an example:
```bash
--principal=admin --password=foobarbaz -U --no-ntp --force-join
```

This logs in as `admin` using the password `foobarbaz` to register the machine. `force-join` joins the container
even if another container was previously joined using the same hostname. We disable ntp, as we can't set the
time in unpriveleged containers and enable unattended installation. This setup assumes that the hostname is
set properly and all IPA information can be obtained from the DNS server. If that's not the case, you may
have to provide additional options.

#### SSSD setup
**You will also have to create the `private/` folder in the folder you will mount to `/var/lib/sss/pipes`!**
```bash
mkdir </path/to/appdata/data/pipes/private>
```

Also initialize the keytab file, if you share it with other containers:
```bash
 echo -e "\0005\0002\c" ></path/to/appdata/data/krb5.keytab>
```

### Running using podman cli

```
podman run --name ipa-client-nas \
  -h nas.example.com \
  -e container=podman \
  -v </path/to/appdata/ipa-options>:/etc/ipa-options \
  -v </path/to/appdata/data/krb5.keytab>:/etc/krb5.keytab \
  -v </path/to/appdata/data/krb5.conf>:/etc/krb5.conf \
  -v </path/to/appdata/data/krb5.conf.d>:/etc/krb5.conf.d \s
  -v </path/to/appdata/data/pipes>:/var/lib/sss/pipes \
  docker.io/jpf91/ipa-client
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 22:22` would expose port `22` from inside the container to be accessible from the host's IP on port `22` outside the container.

| Parameter | Function |
| :----: | --- |
| `-h nas.example.com` | Set the hostname, must be fully qualified. |
| `-v /etc/ipa-options` | Installation options directly passed to `ipa-client-install`. See above for an example. |
| `-v /etc/krb5.keytab` | The container will write kerberos information to this file. Share it with your other containers. |
| `-v /etc/krb5.conf` | The container will write kerberos information to this file. Share it with your other containers. |
| `-v /etc/krb5.conf.d` | The container will write kerberos information to this file. Share it with your other containers. |
| `-v /var/lib/sss/pipes/` | The conainer will make the SSSD API available here. Share it with your other containers. |

## Support Info

* Shell access whilst the container is running: `podman exec -it ipa-client-nas /bin/bash`
* To monitor the logs of the container in realtime: `podman logs -f ipa-client-nas`. FIXME: This does not provide all logs, those are logged to the journal in the container.
* Report bugs [here](https://github.com/jpf91/docker-ipa-client).

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/jpf91/docker-ipa-client.git
cd docker-ipa-client
podman build \
  -t docker.io/jpf91/ipa-client:latest .
```

## Versions

* **03.04.21:** - Initial Release.
