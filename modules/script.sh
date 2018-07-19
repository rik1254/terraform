#! /bin/bash

cat >/home/centos/puppet-install.sh <<EOF
#! /bin/bash
source "$(dirname "$0")/util.sh"
set -e
# puppet-install
#
# Installs and configures a puppetmaster server.
#
yum install -y puppet-agent
source /etc/profile
# FIXME: remove r10k from profile::puppetserver
/opt/puppetlabs/puppet/bin/gem list --local -i r10k >/dev/null || /opt/puppetlabs/puppet/bin/gem install r10k
mkdir -p /etc/puppetlabs/r10k; touch /etc/puppetlabs/r10k/r10k.yaml
# source /etc/profile has an unset variable; set -u after that
set -u
PUPPET_PATH=/etc/puppetlabs/code/environments/production
HIERA_YAML_PATH="${PUPPET_PATH}/hiera.yaml"
HIERA_DATA_PATH="${PUPPET_PATH}/hieradata"

mkdir -p "${HIERA_DATA_PATH}"
cp -r "$(dirname "$0")/../config/puppetmaster/"* "${HIERA_DATA_PATH}/"
mv "${HIERA_DATA_PATH}/hiera.yaml" "${HIERA_YAML_PATH}"
rm -f /etc/puppetlabs/puppet/hiera.yaml
cp -r "${DEPLOYMENT_SUITE}/"* "${PUPPET_PATH}/"

# ensure that puppetserver can connect to the puppetdb locally
FQDN=$(facter -p fqdn)
puppet resource host "$(uname -n)" host_aliases="${FQDN}"

FACTER_pp_role=roles::puppetserver puppet apply \
  --modulepath="${PUPPET_PATH}/modules:${PUPPET_PATH}/site" \
  "${PUPPET_PATH}/manifests/site.pp"
EOF

sudo chmod +x /home/centos/puppet-install.sh
