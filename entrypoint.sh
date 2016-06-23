#!/bin/bash
set -e

printf "Starting FusionDirectory ... ";

if [ -z ${LDAP_DOMAIN} ] ; then
    printf "\n\nLDAP_DOMAIN is not defined!\n"
    exit 1
fi

if [ -z ${LDAP_ROOTPW} ] ; then
    printf "\n\nLDAP_ROOTPW is not defined!\n"
    exit 1
fi

IFS='.' read -a domain_elems <<< "${LDAP_DOMAIN}"

suffix=""
for elem in "${domain_elems[@]}" ; do
    if [ "x${suffix}" = x ] ; then
        suffix="dc=${elem}"
    else
        suffix="${suffix},dc=${elem}"
    fi
done

if [ -z ${LDAP_ROOTDN} ] ; then
    BASEDN="dc=$(echo ${LDAP_DOMAIN} | sed 's/^\.//; s/\.$//; s/\./,dc=/g')"
    LDAP_ROOTDN="cn=${LDAP_ROOT},${BASEDN}"

    printf "\n\n!!!!LDAP_ROOTDN is not defined and set to '${LDAP_ROOTDN}'!!!!\n"
fi


cat <<EOF > /etc/fusiondirectory/fusiondirectory.conf
<?xml version="1.0"?>
<conf>

  <!-- Services **************************************************************
    Old services that are not based on simpleService needs to be listed here
   -->
  <serverservice>
    <tab class="serviceDHCP"        />
    <tab class="serviceDNS"         />
  </serverservice>

  <!-- Main section **********************************************************
       The main section defines global settings, which might be overridden by
       each location definition inside.

       For more information about the configuration parameters, take a look at
       the FusionDirectory.conf(5) manual page.
  -->
  <main default="default"
        logging="TRUE"
        displayErrors="FALSE"
        forceSSL="FALSE"
        templateCompileDirectory="/var/spool/fusiondirectory/"
        debugLevel="0"
    >

    <!-- Location definition -->
    <location name="default"
        config="ou=fusiondirectory,ou=configs,ou=systems,${suffix}">

        <referral URI="${LDAP_SERVER_URL}/${suffix}"
                        adminDn="$LDAP_ROOTDN"
                        adminPassword="$LDAP_ROOTPW" />
    </location>
  </main>
</conf>
EOF

chmod 640 /etc/fusiondirectory/fusiondirectory.conf
chown root:www-data /etc/fusiondirectory/fusiondirectory.conf

yes Yes | fusiondirectory-setup --check-config

exec "$@"
