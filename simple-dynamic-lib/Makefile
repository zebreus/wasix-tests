
WASMER?=wasmer
CC ?= cc
CXX ?= c++
LD ?= cc

# This is technically only required for the library

MAIN_LDFLAGS=$(LDFLAGS)
MAIN_LDFLAGS+=-L$(shell pwd)
MAIN_LDFLAGS+=-lside
MAIN_LDFLAGS+=-Wl,--import-memory
MAIN_LDFLAGS+=-Wl,-pie
MAIN_LDFLAGS+=-Wl,--export-all
# Export all libc symbols
MAIN_LDFLAGS+=-Wl,--whole-archive,-lc,-lutil,-lresolv,-lrt,-lm,-lpthread,-lc++,-lc++abi,-lwasi-emulated-mman,-lwasi-emulated-getpid,--no-whole-archive

SIDE_LDFLAGS=$(LDFLAGS)
SIDE_LDFLAGS+=--no-standard-libraries -nostdlib++ -Wl,--no-entry
SIDE_LDFLAGS+=-Wl,--unresolved-symbols=import-dynamic
SIDE_LDFLAGS+=--shared

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c $< -o $@

%.wasm: %.o Makefile
	$(LD) $(MAIN_LDFLAGS) -o $@ $<

lib%.so: %.o Makefile
	$(LD) $(SIDE_LDFLAGS) -o $@ $<

clean:
	rm -f *.o *.wasm *.log *.a *.so