# some testcases for wasix

Before working on this repo, verify that you can execute the tests. Run `bash test.sh` in the root directory.  The individual test directories expect a WASIX sysroot and the compiler wrappers found in `lib/wrappers/`.  Set `WASIX_SYSROOT` accordingly and prepend the `lib/wrappers/` directory to your `PATH`:

```bash
export WASIX_SYSROOT=/wasix-sysroot
export PATH="$(pwd)/scripts:$PATH"
# choose which toolchain to test
export CC=wasix-clang CXX=wasix-clang++ LD=wasix-clang
```

Use `emscripten-clang`/`emscripten-clang++` for Emscripten builds.

All tests are executed with `wasmer` by default.  You can override the binary by setting the `WASMER` environment variable.

Below is a list of tests that are currently known to be broken.  Fixing them most likely involves changes in `wasix-libc` or `wasmer`, which is out of scope for this repository.  If you notice that a broken test starts passing (or a new test breaks) please update this file.  Also update this file if you change the repository structure or the build infrastructure.

Please update this file with detailed instructions for everything that will affect the next agent or human.
## Testing policy

Always run `bash test.sh` after modifying any files.
Document the results in your pull request description. If tests fail because required tooling is missing, note this but still attempt to run them.

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

Tests that are currently disabled because they fail:
- `minimal-threadlocal`
- `extern-threadlocal-nopic`

The top-level `test.sh` script skips these tests.

## CI notes

This repository now includes a GitHub Actions workflow located at
`.github/workflows/ci.yml`. The workflow installs a WASIX toolchain and runs
`bash test.sh`. It executes automatically on every pull request targeting the
`main` branch. If the build infrastructure changes or additional environment
variables become necessary, document the changes here so the CI remains
reliable. The toolchain installation steps are mirrored in `lib/setup-wasix.sh`. Your environment already has an installed toolchain.
Running this script locally prepares the environment in the same way as the CI.

Tests rely on a proper terminal definition for colored output. If you run the
tests manually, ensure `TERM` is set to `xterm-256color` and
`WASIX_SYSROOT=/wasix-sysroot` before invoking `bash test.sh`.
