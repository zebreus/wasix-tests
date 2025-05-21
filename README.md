# wasix-tests

Collection of small C/C++ test cases for the [WASIX](https://github.com/wasix-org) toolchain.
Each test lives in its own directory with a `Makefile` and a `test.sh` script.

## Requirements

* `clang-19` and `clang++-19`
* a WASIX sysroot – set the `WASIX_SYSROOT` environment variable to its path
* [`wasmer`](https://github.com/wasmerio/wasmer) (override with `WASMER` env var)
* `wasm-tools` or `wabt` (optional, for inspecting generated modules)

## Running tests

Run `bash scripts/setup-wasix.sh` once to install the toolchain, then execute
`bash test.sh`. Ensure `WASIX_SYSROOT=/wasix-sysroot` is set in the environment.

Alternatively:

1. Ensure `WASIX_SYSROOT` points to your WASIX installation.
2. If `tput` errors appear when running the tests, export `TERM=xterm` to provide
   a basic terminal description.
3. Execute `bash test.sh` in the repository root.  The script iterates over all
   subdirectories and invokes their individual `test.sh` files.
3. Use `bash clean.sh` to remove build artefacts.

You may also run the `test.sh` inside a specific test directory to build and run
just that test.



## Adding tests

Run `bash create-test.sh <new-test-name>` to create a new test directory based on
the `helloworld` example.  Adjust the generated files as necessary.
