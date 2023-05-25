#!/bin/bash

ONEC_RELEASE=`echo "$ONEC_VERSION" | cut -d . -f 3`
echo "Release: ""$ONEC_RELEASE"
nls_install="ru"

if [[ "$ONEC_RELEASE" -lt "20" ]]; then
    case "$INSTALLER_TYPE" in
      server)
            dpkg -i 1c-enterprise*-{common,server}_*.deb; \
          ;;
      client)
            dpkg -i 1c-enterprise*-{common,server,client}_*.deb; \
          ;;
    esac
else
    nls_install="ru"
    case "$INSTALLER_TYPE" in
      server)
            set -x
	    echo $nls_install
	    ./setup-full-"$ONEC_VERSION"-x86_64.run --mode unattended --enable-components server,$nls_install
          ;;
      client)
	    ./setup-full-"$ONEC_VERSION"-x86_64.run --mode unattended --enable-components client_full,server_admin,$nls_install
          ;;
      all)
        ./setup-full-"$ONEC_VERSION"-x86_64.run --mode unattended --enable-components server,client_full,server_admin,$nls_install
        ;;
    esac
fi
