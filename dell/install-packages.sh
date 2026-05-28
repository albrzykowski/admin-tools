#!/bin/bash

set -e

USER_NAME=$(logname)

apt update
apt upgrade -y

apt install -y --no-install-recommends \
  firmware-linux \
  firmware-misc-nonfree \
  git \
  htop \
  curl \
  nano \
  unzip 
