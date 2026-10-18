#!/usr/bin/env bash
# ==============================================================================
#  install_deps.sh — bootstrap the open-source toolchain used by ReconScope
#  Everything installed here is free / open-source. No API keys required.
# ==============================================================================

set -euo pipefail

C_RESET=""; C_GREEN=""; C_YELLOW=""; C_BLUE=""; C_RED=""; C_BOLD=""
if [[ -t 1 ]]; then
    C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'
    C_GREEN=$'\033[1;32m'; C_YELLOW=$'\033[1;33m'
    C_BLUE=$'\033[1;34m';   C_RED=$'\033[1;31m'
fi

ok()   { printf '%s✔%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
info() { printf '%s→%s %s\n' "$C_BLUE"  "$C_RESET" "$*"; }
warn() { printf '%s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*"; }
err()  { printf '%s✖%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; }

have() { command -v "$1" >/dev/null 2>&1; }

# ------------------------------------------------------------------------------
# Detect package manager / platform
# ------------------------------------------------------------------------------
PKG=""
if have apt-get; then PKG="apt"; elif have dnf; then PKG="dnf"; elif have yum; then PKG="yum"
elif have pacman; then PKG="pacman"; elif have apk; then PKG="apk"; elif have brew; then PKG="brew"; fi

SUDO=""
if [[ "$(id -u)" -ne 0 ]]; then
    if have sudo; then SUDO="sudo"; else
        warn "Not running as root and sudo is unavailable — package installs may fail."
    fi
fi

# ------------------------------------------------------------------------------
# Go toolchain (needed for the Go-based recon tools)
# ------------------------------------------------------------------------------
ensure_go() {
    if have go; then
        ok "Go toolchain present: $(go version | awk '{print $3}')"
        return 0
    fi
    warn "Go toolchain not found — required to build subfinder / httpx / assetfinder."
    case "$PKG" in
        apt)   $SUDO apt-get update -qq && $SUDO apt-get install -y golang-go ;;
        dnf|yum) $SUDO "$PKG" install -y golang ;;
        pacman) $SUDO pacman -S --noconfirm go ;;
        apk)   $SUDO apk add --no-cache go ;;
        brew)  brew install go ;;
        *) err "Please install Go manually from https://go.dev/dl/"; return 1 ;;
    esac
    if have go; then
        ok "Go installed: $(go version | awk '{print $3}')"
    else
        err "Go install failed."
        return 1
    fi
}

# Install a Go-based binary; skip when already present
go_install() {
    local name="$1" pkg="$2" bin=""
    if have "$name"; then ok "$name already installed -> $(command -v "$name")"; return 0; fi
    info "Installing $name via: go install $pkg"
    if GOPATH_BIN="$(go env GOPATH 2>/dev/null)/bin"; then bin="$GOPATH_BIN/$name"; fi
    if go install -v "$pkg" 2>&1 | tail -3; then
        if [[ -x "$bin" ]]; then
            ok "$name installed -> $bin"
            case ":$PATH:" in
                *":$GOPATH_BIN:"*) : ;;
                *) warn "Add to PATH:  export PATH=\"\$PATH:$GOPATH_BIN\"" ;;
            esac
            return 0
        fi
    fi
    err "Failed to install $name"
    return 1
}

# Install a system package
pkg_install() {
    local name="$1" apk_name="${2:-$1}"
    if have "$name"; then ok "$name already installed"; return 0; fi
    case "$PKG" in
        apt)    $SUDO apt-get update -qq && $SUDO apt-get install -y "$apk_name" ;;
        dnf)    $SUDO dnf install -y "$apk_name" ;;
        yum)    $SUDO yum install -y "$apk_name" ;;
        pacman) $SUDO pacman -S --noconfirm "$apk_name" ;;
        apk)    $SUDO apk add --no-cache "$apk_name" ;;
        brew)   brew install "$apk_name" ;;
        *) warn "No supported package manager for '$name'"; return 1 ;;
    esac
    if have "$name"; then
        ok "$name installed"
    else
        warn "$name still missing"
    fi
}

# ------------------------------------------------------------------------------
main() {
    printf '\n%s  ReconScope — dependency installer%s\n\n' "$C_BOLD" "$C_RESET"

    info "System packages"
    pkg_install jq jq
    pkg_install curl curl
    pkg_install ca-certificates ca-certificates

    info "Building Go-based recon tools (this can take a few minutes)"
    ensure_go || warn "Continuing — some tools will be skipped."
    if have go; then
        go_install subfinder   github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
        go_install httpx       github.com/projectdiscovery/httpx/cmd/httpx@latest
        go_install assetfinder github.com/tomnomnom/assetfinder@latest
        go_install anewer      github.com/tomnomnom/anew@latest
        go_install dnsx        github.com/projectdiscovery/dnsx/cmd/dnsx@latest
    fi

    printf '\n%s  Verification%s\n' "$C_BOLD" "$C_RESET"
    local t
    for t in subfinder assetfinder httpx jq curl anewer dnsx; do
        if have "$t"; then
            ok "$t -> $(command -v "$t")"
        else
            warn "$t missing"
        fi
    done

    printf '\n%sTip%s: the PyPI package "httpx" is a different project from ProjectDiscovery httpx.\n' "$C_BOLD" "$C_RESET"
    cat <<'EOF'
     If `httpx -version` does not mention projectdiscovery, install the Go one and
     ensure $HOME/go/bin takes precedence in PATH.
EOF

    printf 'Next:  ./reconscope.sh -d example.com\n\n'
}

main "$@"
