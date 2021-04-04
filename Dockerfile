# https://fedoramagazine.org/building-smaller-container-images/
FROM registry.fedoraproject.org/fedora-minimal:33

# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/using_containerized_identity_management_services/configuring-the-sssd-container-to-provide-identity-and-authentication-services-on-atomic-host
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/using_containerized_identity_management_services/deploying-sssd-containers-with-different-configurations
RUN microdnf install \
    sssd-client krb5-workstation ipa-client iputils && \
    microdnf clean all

RUN systemctl disable proc-fs-nfsd.mount nfs-idmapd.service nfs-mountd.service nfs-server.service nfsdcld.service autofs.service sssd-nss.socket sssd-pam.socket sssd-pam-priv.socket systemctl disable sssd-sudo.socket systemd-networkd-wait-online
RUN systemctl mask var-lib-nfs-rpc_pipefs.mount

# Setting the domain name fails in unprivileged container
ADD nis-domainname.override /etc/systemd/system/nis-domainname.service.d/override.conf

# Files to perform the IPA join
ADD initial-setup.service /etc/systemd/system/initial-setup.service
ADD initial-setup.sh /usr/sbin/initial-setup.sh
RUN systemctl enable initial-setup.service

ENTRYPOINT ["/sbin/init"]
