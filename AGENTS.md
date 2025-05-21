# some testcases for wasix

Before working on this repo, verify that you can execute tests. `bash test.sh` in the root should suffice. Below is a list of tests that are currently broken. Fixing them most likely involves changes in wasix-libc or wasmer, which is not in the scope of this repo. In case they do get fix, or new broken tests are added, please leave a note in this file. If you change something about the structure of the repo or the build infra, update this file.

Please update this file with detailed instructions for everything, that will affect the next agent or human.

TODO: Write instructions on how to inspect generated wasm (For example with `wasm-tools print FILE | head -n30`)
TODO: Improve this file

## Notes

Tests that are currently broken:
- `minimal-threadlocal`
- `extern-threadlocal-nopic`

## CI notes

This repository now includes a GitHub Actions workflow located at
`.github/workflows/ci.yml`. The workflow installs a WASIX toolchain and runs
`bash test.sh`. It executes automatically on every pull request targeting the
`main` branch. If the build infrastructure changes or additional environment
variables become necessary, document the changes here so the CI remains
reliable.
