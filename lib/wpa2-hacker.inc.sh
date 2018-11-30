#!/bin/bash
WPA2_HACKER_RPMS=( reaver sqlite-devel libpcap-devel aircrack-ng )
WIFI_IFACE='wlp4s0'
MON_IFACE="${WIFI_IFACE}mon"
DUMP_PATH='/dump/'
function install_packages() { #TODO - finish me ....
  declare -a pkg_names=("${!1}")
  for pkg in "${pkg_names[@]}"; do {
    echo sudo dnf -y install $pkg
    sudo dnf -y install $pkg > /dev/null 2>&1 && \
      echo $pkg installed || \
      return $?;
  }; done;
  return 0;
}
function start_airmon() {
  WIFI_IFACE=$1
  sudo airmon-ng start $WIFI_IFACE -w /
}
function stop_airmon() {
  MON_IFACE=$1
  sudo airmon-ng stop $MON_IFACE
}
start_dump() {
  MON_IFACE=$1
  DUMP_PATH=$2
  sudo airodump-ng $MON_IFACE -t WPA2 -i -w $DUMP_PATH
}
#stop_dump() { }

#parse_dump_bssids() { }

