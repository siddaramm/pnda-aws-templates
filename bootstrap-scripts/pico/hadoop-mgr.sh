#!/bin/bash -v

# This script runs on instances with a node_type tag of "hadoop-mgr"
# It sets the roles that determine what software is installed
# on this instance by platform-salt scripts and the minion
# id and hostname

# The pnda_env-<cluster_name>.sh script generated by the CLI should
# be run prior to running this script to define various environment
# variables
set -e

# The hadoop:role grain is used by the cm_setup.py (in platform-salt) script to
# place specific hadoop roles on this instance.
# The mapping of hadoop roles to hadoop:role grains is
# defined in the cfg_<flavor>.py.tpl files (in platform-salt)
cat >> /etc/salt/grains <<EOF
hadoop:
  role: MGR01
roles:
  - oozie_database
  - mysql_connector
  - hue
  - opentsdb
  - grafana

EOF

cat >> /etc/salt/minion <<EOF
id: $PNDA_CLUSTER-hadoop-mgr-1
EOF

echo $PNDA_CLUSTER-hadoop-mgr-1 > /etc/hostname
hostname $PNDA_CLUSTER-hadoop-mgr-1

service salt-minion restart
