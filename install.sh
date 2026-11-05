#!/usr/bin/env bash
# Jellyfin VDR Proxy Deployment & Automation script with system prerequisite checking

set -e

# System requirements and path validation
BINARY_TARGET="/usr/bin/jellyfin-vdr-proxy"
CONFIG_DIR="/etc/jellyfin-vdr-proxy"
CONFIG_FILE="${CONFIG_DIR}/config.ini"
SERVICE_FILE="/etc/systemd/system/jellyfin-vdr-proxy.service"

check_prerequisites() {
    echo "[*] Validation: Checking system environment and runtime dependencies..."
    
    # 1. Root privilege verification
    if [ "$EUID" -ne 0 ]; then
        echo "[!] Critical Error: Execution denied. Please restart this installer with root environment privileges (e.g., sudo)." >&2
        exit 1
    fi

    # 2. Python 3 package availability check
    if ! command -v python3 &> /dev/null; then
        echo "[!] Critical Error: Runtime dependency missing. 'python3' package could not be resolved in PATH." >&2
        echo "    -> Please deploy Python 3 via your local package controller (e.g., 'apt install python3' or 'yum install python3') first." >&2
        exit 1
    else
        PYTHON_VERSION=$(python3 --version 2>&1)
        echo "[+] Verified: Runtime layer operational -> ${PYTHON_VERSION}."
    fi
}

install_proxy() {
    check_prerequisites
    echo "[*] Step 1: Deploying primary binary payload..."
    cp jellyfin-vdr-proxy "${BINARY_TARGET}"
    chmod +x "${BINARY_TARGET}"
    echo "[+] Binary successfully linked to: ${BINARY_TARGET}"

    echo "[*] Step 2: Provisioning persistent configuration directories..."
    if [ ! -d "${CONFIG_DIR}" ]; then
        mkdir -p "${CONFIG_DIR}"
    fi

    if [ ! -f "${CONFIG_FILE}" ]; then
        cp config.ini "${CONFIG_FILE}"
        echo "[+] Configuration workspace established at: ${CONFIG_FILE}"
    else
        echo "[-] Preserving pre-existing active configuration matrix file."
    fi

    echo "[*] Step 3: Registering asynchronous systemd background management service layer..."
    cp jellyfin-vdr-proxy.service "${SERVICE_FILE}"
    
    systemctl daemon-reload
    systemctl enable jellyfin-vdr-proxy.service
    systemctl restart jellyfin-vdr-proxy.service
    
    echo "========================================================================"
    echo "[+] Deployment Success! VDR Proxy is successfully mounted and running."
    echo "    - Target Management Layer: systemctl status jellyfin-vdr-proxy.service"
    echo "    - Main Config Target:      ${CONFIG_FILE}"
    echo "========================================================================"
}

uninstall_proxy() {
    if [ "$EUID" -ne 0 ]; then
        echo "[!] Critical Error: Execution denied. Root access required for deinstallation." >&2
        exit 1
    fi

    echo "[*] Commencing rollback: Purging VDR proxy suite components..."

    if systemctl is-active --quiet jellyfin-vdr-proxy.service &>/dev/null; then
        echo "[*] Disengaging background processing and active service execution loops..."
        systemctl stop jellyfin-vdr-proxy.service || true
    fi

    if [ -f "${SERVICE_FILE}" ]; then
        systemctl disable jellyfin-vdr-proxy.service || true
        rm -f "${SERVICE_FILE}"
        systemctl daemon-reload
        echo "[+] Core service engine links deleted."
    fi

    if [ -f "${BINARY_TARGET}" ]; then
        rm -f "${BINARY_TARGET}"
        echo "[+] System binary instance deleted."
    fi

    if [ -d "${CONFIG_DIR}" ]; then
        echo "------------------------------------------------------------------------"
        read -p "[?] Configuration Directive: Purge persistent config tree & keys at ${CONFIG_DIR}? [y/N]: " PURGE_CONF
        if [[ "${PURGE_CONF}" =~ ^[Yy]$ ]]; then
            rm -rf "${CONFIG_DIR}"
            echo "[+] Purged persistent config matrices and custom SSL contexts completely."
        else
            echo "[-] Retaining config matrices structure at ${CONFIG_DIR}."
        fi
    fi

    echo "[+] Uninstallation procedure finished cleanly."
}

show_help() {
    echo "Usage: sudo $0 [OPTION]"
    echo "Available Arguments:"
    echo "  --install      Performs automated checks, binaries positioning, and background activation."
    echo "  --uninstall    Gracefully terminates execution nodes, unlinks system hooks, and clears storage components."
    echo "  --help         Displays this context schema printout."
}

case "$1" in
    --install)
        install_proxy
        ;;
    --uninstall)
        uninstall_proxy
        ;;
    --help|*)
        show_help
        ;;
esac
