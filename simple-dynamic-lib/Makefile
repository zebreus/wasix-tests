ifeq ($(WASIX_SYSROOT),)
$(error Please set WASIX_SYSROOT to the sysroot path of your WASIX installation)
endif

WASMER?=wasmer
CC=clang-19
CXX=clang++-19
LD=clang-19

CFLAGS=""
CFLAGS+=--target=wasm32-wasi
CFLAGS+=--sysroot="${WASIX_SYSROOT}"
CFLAGS+=-matomics -mbulk-memory -mmutable-globals
CFLAGS+=-pthread -mthread-model posix -ftls-model=local-exec
CFLAGS+=-fno-trapping-math -D_WASI_EMULATED_MMAN -D_WASI_EMULATED_SIGNAL -D_WASI_EMULATED_PROCESS_CLOCKS
CFLAGS+=-fPIC
# This is technically only required for the library
CFLAGS+=-fvisibility=default

LDFLAGS=""
LDFLAGS+=--target=wasm32-wasi -fno-rtlib-defaultlib
LDFLAGS+=--sysroot="${WASIX_SYSROOT}"
LDFLAGS+=-Wl,--extra-features=atomics
LDFLAGS+=-Wl,--extra-features=bulk-memory
LDFLAGS+=-Wl,--extra-features=mutable-globals
LDFLAGS+=-Wl,--export=__wasm_call_ctors
LDFLAGS+=-Wl,--export-if-defined=__wasm_apply_data_relocs
LDFLAGS+=-Wl,--experimental-pic
LDFLAGS+=-Wl,--shared-memory

MAIN_LDFLAGS=$(LDFLAGS)
MAIN_LDFLAGS+=-L$(shell pwd)
MAIN_LDFLAGS+=-lside
MAIN_LDFLAGS+=-Wl,--import-memory
MAIN_LDFLAGS+=-Wl,-pie
MAIN_LDFLAGS+=-Wl,--export-all
# Export all libc symbols
LDFLAGS+=-Wl,--whole-archive,-lc,-lutil,-lresolv,-lrt,-lm,-lpthread,-lc++,-lc++abi,-lwasi-emulated-mman,-lwasi-emulated-getpid,--no-whole-archive



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