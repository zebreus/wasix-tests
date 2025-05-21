# WASIX_SYSROOT="$(WASIX_SYSROOT)"

ifeq ($(WASIX_SYSROOT),)
$(error Please set WASIX_SYSROOT to the sysroot path of your WASIX installation)
endif

WASMER?=wasmer
CC=clang-19
CXX=clang++-19
LD=clang++-19

CFLAGS=""
CFLAGS+=--target=wasm32-wasi
CFLAGS+=--sysroot="${WASIX_SYSROOT}"
CFLAGS+=-matomics -mbulk-memory -mmutable-globals
CFLAGS+=-pthread -mthread-model posix -ftls-model=local-exec
CFLAGS+=-fno-trapping-math 
CFLAGS+=-D_WASI_EMULATED_MMAN -D_WASI_EMULATED_SIGNAL -D_WASI_EMULATED_PROCESS_CLOCKS

LDFLAGS=""
LDFLAGS+=--target=wasm32-wasi
LDFLAGS+=--sysroot="${WASIX_SYSROOT}"
LDFLAGS+=-Wl,--extra-features=atomics,--extra-features=bulk-memory,--extra-features=mutable-globals

%.o: %.cpp Makefile
	$(CXX) $(CFLAGS) -c $< -o $@

main.wasm: main.o erryes.o Makefile
	$(LD) $(LDFLAGS) -o $@ main.o erryes.o

run: main.wasm
	$(WASMER) run main.wasm

clean:
	rm -f *.o *.wasm *.log *.a *.so