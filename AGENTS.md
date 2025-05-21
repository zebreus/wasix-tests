# some testcases for wasix

Before working on this repo, verify that you can execute the tests. Run `bash test.sh` in the root directory.  The individual test directories contain Makefiles that expect **clang‑19** and **clang++‑19** and a working WASIX sysroot.  Set the environment variable `WASIX_SYSROOT` to the sysroot path of your WASIX installation before invoking any Makefiles.  Without it the builds will fail.

All tests are executed with `wasmer` by default.  You can override the binary by setting the `WASMER` environment variable.

Below is a list of tests that are currently known to be broken.  Fixing them most likely involves changes in `wasix-libc` or `wasmer`, which is out of scope for this repository.  If you notice that a broken test starts passing (or a new test breaks) please update this file.  Also update this file if you change the repository structure or the build infrastructure.

Please update this file with detailed instructions for everything that will affect the next agent or human.

### Inspecting generated WebAssembly

If you need to look at the produced WebAssembly files (e.g. `*.wasm`, `*.o`, `*.so`)
you can convert them to the text format using the `wasm-tools` package:

```bash
wasm-tools print FILE | head -n 30
```

`wasm2wat` from `wabt` works as well.  This is often useful when debugging relocation problems.

TODO: Improve this file

### Debugging failing tests

If you encounter a failing test and need guidance on how to debug it, see
`docs/debugging-tests.md` for a walkthrough. The document explains how to run
individual test suites, increase build verbosity, and inspect generated
WebAssembly files.

All test scripts source `../lib/test-utils.sh` which provides `build_targets` and
`run_wasm` helper functions.

If `tput` fails while sourcing `lib/assert.sh` (e.g. because `$TERM` is unset),
export `TERM=xterm` before running the tests.

## Notes

`bash test.sh` currently fails in this environment because no WASIX sysroot is
available.  Once a valid sysroot is provided via `WASIX_SYSROOT` the tests
should build and run (with the exceptions listed below).

Tests that are currently broken:
- `minimal-threadlocal`
- `extern-threadlocal-nopic`

## CI notes

This repository now includes a GitHub Actions workflow located at
`.github/workflows/ci.yml`. The workflow installs a WASIX toolchain and runs
`bash test.sh`. It executes automatically on every pull request targeting the
`main` branch. If the build infrastructure changes or additional environment
variables become necessary, document the changes here so the CI remains
reliable. The toolchain installation steps are mirrored in `scripts/setup-wasix.sh`.
Running this script locally prepares the environment in the same way as the CI.

Tests rely on a proper terminal definition for colored output. If you run the
tests manually, ensure `TERM` is set to `xterm-256color` and
`WASIX_SYSROOT=/wasix-sysroot` before invoking `bash test.sh`.
