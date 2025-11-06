#!/bin/bash

# instalacija ARM toolchain
sudo apt update
sudo apt install -y gcc-arm-none-eabi binutils-arm-none-eabi ninja-build cmake python3

# opcioni: postavi PATH ako treba
export PATH=$PATH:/usr/bin
