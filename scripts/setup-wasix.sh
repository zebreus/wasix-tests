#!/usr/bin/env bash
set -euo pipefail

# Install tooling required for building and testing WASIX programs

# If the sysroot already exists we assume the toolchain is installed.
if [ -d "/wasix-sysroot" ]; then
    echo "WASIX sysroot already installed at /wasix-sysroot, skipping setup."
    exit 0
fi

curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
cargo binstall -y wasm-tools

sudo apt update
sudo apt install -y clang-19 llvm-19 llvm-19-dev emscripten nodejs binaryen wabt libpolly-19-dev lld-19 pkg-config libtool unzip

wget http://0x0.st/8wwU.zip
unzip 8wwU.zip
chmod a+x wasmer
sudo mv wasmer /usr/bin/wasmer
rm 8wwU.zip

wget http://0x0.st/8ww5.zip
unzip 8ww5.zip
sudo mv sysroot /wasix-sysroot
rm 8ww5.zip

sudo mkdir -p /usr/lib/llvm-19/lib/clang/19/lib/wasm32-unknown-wasi
sudo cp /wasix-sysroot/lib/wasi/libclang_rt.builtins-wasm32.a /usr/lib/llvm-19/lib/clang/19/lib/wasm32-unknown-wasi/libclang_rt.builtins.a
