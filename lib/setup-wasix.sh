#!/usr/bin/env bash
set -euo pipefail

# Install tooling required for building and testing WASIX programs

# If the sysroot already exists we assume the toolchain is installed.
if [ -d "/wasix-sysroot" ]; then
    echo "WASIX sysroot already installed at /wasix-sysroot, skipping setup."
    exit 0
fi

curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash  > /dev/null
cargo binstall -y wasm-tools

sudo apt update > /dev/null
sudo apt install -y clang-19 llvm-19 llvm-19-dev nodejs binaryen wabt libpolly-19-dev lld-19 pkg-config libtool unzip  > /dev/null

ORIGINAL_DIR=$(pwd)
cd ~
git clone --depth=1 https://github.com/emscripten-core/emsdk.git > /dev/null
cd emsdk
rm -rf .git
./emsdk install 3.1.69 > /dev/null
./emsdk activate 3.1.69
# source "$(pwd)/emsdk_env.sh"
# echo 'source "'$(pwd)'/emsdk_env.sh"' >> $HOME/.bash_profile
# echo 'source "'$(pwd)'/emsdk_env.sh"' >> $HOME/.bashrc
# echo 'source "'$(pwd)'/emsdk_env.sh"' >> $HOME/.profile
if test -n "${GITHUB_PATH:-}" ; then
  echo "$(pwd)" >> $GITHUB_PATH
  echo "$(pwd)/upstream/emscripten" >> $GITHUB_PATH
fi
cd $ORIGINAL_DIR

wget -q http://0x0.st/8xgR.zip -O wasmer.zip > /dev/null
unzip wasmer.zip > /dev/null
chmod a+x wasmer
sudo mv wasmer /usr/bin/wasmer
rm wasmer.zip

wget -q http://0x0.st/8xgk.zip -O sysroot.zip > /dev/null
unzip sysroot.zip > /dev/null
sudo mv sysroot /wasix-sysroot
rm sysroot.zip

sudo mkdir -p /usr/lib/llvm-19/lib/clang/19/lib/wasm32-unknown-wasi
sudo cp /wasix-sysroot/lib/wasi/libclang_rt.builtins-wasm32.a /usr/lib/llvm-19/lib/clang/19/lib/wasm32-unknown-wasi/libclang_rt.builtins.a
