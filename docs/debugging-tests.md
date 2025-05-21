# Debugging Failing Tests

This document outlines a process for investigating and resolving failing WASIX tests.
It assumes the toolchain is installed as described in `README.md` and that the environment
variables `WASIX_SYSROOT` and `WASMER` (optional) are set appropriately.

## 1. Reproduce the Failure

Start by running the tests to see the failure output. From the repository root:

```bash
bash test.sh
```

Check the last lines of the output. Look for the test name and any error messages. Ensure
`WASIX_SYSROOT` points to a valid sysroot. Without it, all builds fail with a `Please set WASIX_SYSROOT` message.

## 2. Build a Single Test

To isolate a test, change into its directory and run `bash test.sh`. Example:

```bash
cd helloworld
bash test.sh
```

This script compiles the test using `make` and then runs the produced module with `wasmer`.
If compilation fails, inspect the `*.o` and `*.wasm` files using `wasm-tools print` or
`wasm2wat` to confirm that expected symbols are present.

## 3. Increase Verbosity

The Makefiles in this repository already print the compiler and linker commands
as they execute.  Passing `V=1` has no additional effect.  If you need even more
details, you can temporarily enable shell tracing in a `test.sh` script by
adding `set -x` near the top.

## 4. Run Under a Debugger

`wasmer` supports `--debug` and `--invoke` flags. For the most detailed runtime
traces, set the environment variable `WASMER_LOG=trace` before invoking the
test binary.  `wasmtime` may also be useful if available.

```bash
WASMER_LOG=trace wasmer run test.wasm
```

Look for traps or missing imports. In some cases, enabling `set -x` in the `test.sh` script can
help trace the commands being executed.

## 5. Compare with a Working Test

If a similar test passes, diff its `Makefile` and source files against the failing one. Small
configuration differences (e.g. `-shared` vs. `-static` or `-fPIC` flags) can lead to subtle
linking or runtime issues.

## 6. Consult the WASIX Documentation

This repository does not include local WASIX manuals. If the failure seems
related to the runtime or the standard library, check the upstream WASIX
project and the `wasmer` README for information about supported features and
required runtime flags. Some functionality may still be experimental or need
specific command-line options.

## 7. Update Documentation

After identifying the root cause and fixing the test, update `AGENTS.md` with any changes that
will assist future contributors. Document new environment variables, required tools, or anything
that deviates from the default workflow.

