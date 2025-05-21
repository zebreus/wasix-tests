# wasix-tests
Some test cases that worked on my machine

## Running tests

Before running tests, ensure that the environment variable `WASIX_SYSROOT` is set
to the path of your WASIX installation. The Makefiles rely on this variable to
find the correct sysroot. Once set, run the tests with:

```bash
bash test.sh
```

## Adding tests

Before creating a new test, export `WASIX_SYSROOT` as described above and then run:

```bash
bash create-test.sh
```
