# some testcases for wasix

Before working on this repo, verify that you can execute tests. `bash test.sh` in the root should suffice. Below is a list of tests that are currently broken. Fixing them most likely involves changes in wasix-libc or wasmer, which is not in the scope of this repo. In case they do get fix, or new broken tests are added, please leave a note in this file. If you change something about the structure of the repo or the build infra, update this file.

Please update this file with detailed instructions for everything, that will affect the next agent or human.

TODO: Write instructions on how to inspect generated wasm (For example with `wasm-tools print FILE | head -n30`)
TODO: Improve this file

All test scripts source `../lib/test-utils.sh` which provides `build_targets` and
`run_wasm` helper functions.

If `tput` fails while sourcing `lib/assert.sh` (e.g. because `$TERM` is unset),
export `TERM=xterm` before running the tests.

## Notes

Tests that are currently broken:
- `minimal-threadlocal`
- `extern-threadlocal-nopic`

