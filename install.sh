#!/bin/sh
# SingLinkVPN installer. Run with sh install.sh [-p singlinkvpn-gui]
# [--channel stable|candidate|beta|edge]. Uses the signed Snap Store package.
set -eu
channel=stable
while [ "$#" -gt 0 ]; do
  case "$1" in
    -p)
      [ "$#" -ge 2 ] || { echo 'Missing package name' >&2; exit 2; }
      case "$2" in singlinkvpn|singlinkvpn-gui) ;; *) echo 'Unknown package' >&2; exit 2;; esac
      shift 2 ;;
    --channel)
      [ "$#" -ge 2 ] || { echo 'Missing channel' >&2; exit 2; }
      case "$2" in stable|candidate|beta|edge) channel=$2;; *) echo 'Unknown channel' >&2; exit 2;; esac
      shift 2 ;;
    -h|--help) echo 'Usage: sh install.sh [-p singlinkvpn-gui] [--channel stable|candidate|beta|edge]'; exit 0;;
    *) echo "Unknown option: $1" >&2; exit 2;;
  esac
done
[ "$(uname -s)" = Linux ] || { echo 'This installer is for Linux.' >&2; exit 1; }
case "$(uname -m)" in x86_64|aarch64|arm64) ;; *) echo 'Supported CPUs: x86_64 and ARM64.' >&2; exit 1;; esac
as_root() {
  if [ "$(id -u)" -eq 0 ]; then "$@"; else sudo "$@"; fi
}
if ! command -v snap >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    as_root apt-get update
    as_root apt-get install -y snapd
    as_root systemctl enable --now snapd.socket
  else
    echo 'Install snapd for your distribution: https://snapcraft.io/docs/installing-snapd' >&2
    exit 1
  fi
fi
if snap list singlinkvpn >/dev/null 2>&1; then
  as_root snap refresh singlinkvpn --channel="$channel"
else
  as_root snap install singlinkvpn --channel="$channel"
fi
# These interfaces are required to create the VPN interface and manage routes.
as_root snap connect singlinkvpn:network-control
as_root snap connect singlinkvpn:firewall-control
as_root snap restart singlinkvpn.core-service
echo 'SingLinkVPN installed. Open it from your app menu or run: snap run singlinkvpn'
