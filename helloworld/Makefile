# WASIX_SYSROOT="$(WASIX_SYSROOT)"

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
CFLAGS+= -pthread -mthread-model posix -ftls-model=local-exec
CFLAGS+= -fno-trapping-math -D_WASI_EMULATED_MMAN -D_WASI_EMULATED_SIGNAL
CFLAGS+= -D_WASI_EMULATED_PROCESS_CLOCKS
CFLAGS+= -fvisibility=default
CFLAGS+= -fPIC

LDFLAGS=""
LDFLAGS+=--target=wasm32-wasi
LDFLAGS+=--sysroot="${WASIX_SYSROOT}"
LDFLAGS+=-Wl,--experimental-pic
LDFLAGS+=-Wl,-pie
LDFLAGS+=-Wl,--import-memory
LDFLAGS+=-Wl,--import-memory
LDFLAGS+=-Wl,--shared-memory
LDFLAGS+=-Wl,--export-if-defined=__wasm_apply_data_relocs
LDFLAGS+=-Wl,--export-if-defined=_ZTH5errno
LDFLAGS+=-Wl,--export-if-defined=__cxa_thread_atexit_impl
LDFLAGS+=-Wl,--export=__wasm_call_ctors
LDFLAGS+=-Wl,--extra-features=atomics
LDFLAGS+=-Wl,--extra-features=bulk-memory
LDFLAGS+=-Wl,--extra-features=mutable-globals
LDFLAGS+=-Wl,--whole-archive
LDFLAGS+=-Wl,-lc
LDFLAGS+=-Wl,-lutil
LDFLAGS+=-Wl,-lresolv
LDFLAGS+=-Wl,-lrt
LDFLAGS+=-Wl,-lm
LDFLAGS+=-Wl,-lpthread
LDFLAGS+=-Wl,-lwasi-emulated-mman
LDFLAGS+=-Wl,-lwasi-emulated-getpid
LDFLAGS+=-Wl,--export-all
LDFLAGS+=-Wl,--no-whole-archive
LDFLAGS+=-Wl,-lc++
LDFLAGS+=-Wl,-lc++abi

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c $< -o $@

helloworld.wasm: helloworld.o Makefile
	$(LD) $(LDFLAGS) -o $@ $<

clean:
	rm -f *.o *.wasm *.log *.a *.so