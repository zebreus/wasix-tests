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

git clone --depth=1 https://github.com/emscripten-core/emsdk.git > /dev/null
cd emsdk
./emsdk install 3.1.69 > /dev/null
./emsdk activate 3.1.69
source "$(pwd)/emsdk_env.sh"
echo 'source "'$(pwd)'/emsdk_env.sh"' >> $HOME/.bash_profile
echo 'source "'$(pwd)'/emsdk_env.sh"' >> $HOME/.bashrc
echo 'source "'$(pwd)'/emsdk_env.sh"' >> $HOME/.profile
if test -n "${GITHUB_PATH:-}" ; then
  echo "$(pwd)" >> $GITHUB_PATH
  echo "$(pwd)/upstream/emscripten" >> $GITHUB_PATH
fi

cd ..

wget -q http://0x0.st/8wwU.zip > /dev/null
unzip 8wwU.zip > /dev/null
chmod a+x wasmer
sudo mv wasmer /usr/bin/wasmer
rm 8wwU.zip

wget -q http://0x0.st/8ww5.zip > /dev/null
unzip 8ww5.zip > /dev/null
sudo mv sysroot /wasix-sysroot
rm 8ww5.zip

sudo mkdir -p /usr/lib/llvm-19/lib/clang/19/lib/wasm32-unknown-wasi
sudo cp /wasix-sysroot/lib/wasi/libclang_rt.builtins-wasm32.a /usr/lib/llvm-19/lib/clang/19/lib/wasm32-unknown-wasi/libclang_rt.builtins.a
