#!/bin/bash

if [ ! -f "/etc/ipa-options" ]; then
	echo "The configuration file /etc/ipa-options does not exist!" >&2
	exit 1
fi
IPA_CLIENT_INSTALL_OPTS=$(cat /etc/ipa-options)
/usr/sbin/ipa-client-install $IPA_CLIENT_INSTALL_OPTS
echo "FreeIPA-enrolled"