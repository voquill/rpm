# Voquill RPM Repository

RPM package repository for [Voquill](https://voquill.com) desktop app.

## Quick Install

```bash
curl -fsSL https://voquill.github.io/rpm/install.sh | bash
```

## Manual Setup (Fedora/RHEL)

```bash
# Import GPG key
sudo rpm --import https://voquill.github.io/rpm/gpg-key.asc

# Add repository
sudo tee /etc/yum.repos.d/voquill.repo > /dev/null << 'EOF'
[voquill-stable]
name=Voquill Desktop (stable)
baseurl=https://voquill.github.io/rpm/packages/stable
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://voquill.github.io/rpm/gpg-key.asc
EOF

# Install
sudo dnf install voquill-desktop
```

## Available Packages

- `voquill-desktop` — Stable release
- `voquill-desktop-dev` — Development release (use `--dev` flag with install script)

## Upgrade

```bash
sudo dnf upgrade voquill-desktop
```
