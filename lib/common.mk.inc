SHELL = bash
CC ?= clang
CXX ?= clang++

# Force rebuild if the Makefile or the arguments change
.PHONY: phony
.CONFIG: phony
	@if [[ `cat .CONFIG 2>&1` != '$(shell shasum $(shell which $(CC) $(CXX)) Makefile ../lib/common.mk.inc)' ]]; then echo -n '$(shell shasum $(shell which $(CC) $(CXX)) Makefile ../lib/common.mk.inc)' >.CONFIG; fi

%.o: %.c .CONFIG
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.cpp .CONFIG
	$(CXX) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o *.wasm *.log *.a *.so main .CONFIG

# Reset default goal
.DEFAULT_GOAL :=
