#!/usr/bin/env bash
set -euo pipefail

CHANNEL="stable"
PKG_NAME="voquill-desktop"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dev)
      CHANNEL="dev"
      PKG_NAME="voquill-desktop-dev"
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

if ! command -v dnf &>/dev/null && ! command -v zypper &>/dev/null; then
  echo "Error: This script requires dnf (Fedora/RHEL) or zypper (openSUSE)." >&2
  echo "For Debian/Ubuntu, use: curl -fsSL https://voquill.github.io/apt/install.sh | bash" >&2
  exit 1
fi

if ! command -v curl &>/dev/null; then
  echo "Error: curl not found. Please install curl first." >&2
  exit 1
fi

REPO_BASE="https://voquill.github.io/rpm"
GPG_KEY_URL="${REPO_BASE}/gpg-key.asc"

echo "Adding Voquill RPM repository (${CHANNEL} channel)..."

sudo rpm --import "${GPG_KEY_URL}" || {
  echo "Error: Failed to import the GPG signing key." >&2
  echo "Please check your network connection and try again." >&2
  exit 1
}

if command -v dnf &>/dev/null; then
  sudo tee /etc/yum.repos.d/voquill.repo > /dev/null << EOF
[voquill-${CHANNEL}]
name=Voquill Desktop (${CHANNEL})
baseurl=${REPO_BASE}/packages/${CHANNEL}
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=${GPG_KEY_URL}
EOF

  echo "Installing ${PKG_NAME}..."
  sudo dnf install -y "${PKG_NAME}"

elif command -v zypper &>/dev/null; then
  sudo rpm --import "${GPG_KEY_URL}"
  sudo zypper addrepo --gpgcheck "${REPO_BASE}/packages/${CHANNEL}" "voquill-${CHANNEL}" || true

  echo "Installing ${PKG_NAME}..."
  sudo zypper install -y "${PKG_NAME}"
fi

echo "Done! Voquill has been installed."
