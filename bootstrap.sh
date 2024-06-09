#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(dirname $(readlink -f $0))
BOOTSTRAP_SCRIPT_DIR=${SCRIPT_DIR}/scripts

sudo apt install \
    build-essential \
    docker.io \
    git \
    htop \
    openssh-client \
    python3-requests \
    python3-tabulate \
    python3-venv \
    ripgrep \
    rsync \
    tmux \
    wakeonlan

for SCRIPT in $(ls ${BOOTSTRAP_SCRIPT_DIR});do
    ${BOOTSTRAP_SCRIPT_DIR}/${SCRIPT}
done
