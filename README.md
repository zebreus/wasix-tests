# wasix-tests
Some test cases that worked on my machine

## Running tests

Before running tests, ensure that the environment variable `WASIX_SYSROOT` is set
to the path of your WASIX installation. The Makefiles rely on this variable to
find the correct sysroot. If `tput` errors appear when running the tests, export
`TERM=xterm` to provide a basic terminal description. Once the environment is
configured, run the tests with:

```bash
bash test.sh
```

## Adding tests

Before creating a new test, export `WASIX_SYSROOT` as described above and then run:

```bash
bash create-test.sh
```
