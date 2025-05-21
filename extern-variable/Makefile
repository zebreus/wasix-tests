
WASMER?=wasmer
CC ?= cc
CXX ?= c++
LD ?= cc

# Export all libc symbols
MAIN_LDFLAGS+=-Wl,--whole-archive,-lc,-lutil,-lresolv,-lrt,-lm,-lc++,-lc++abi,-lpthread,-lwasi-emulated-mman,-lwasi-emulated-getpid,--no-whole-archive

%.o: %.cpp Makefile
	$(CXX) $(CFLAGS) -c $< -o $@

main.wasm: main.o erryes.o Makefile
	$(LD) $(LDFLAGS) -o $@ main.o erryes.o

run: main.wasm
	$(WASMER) run main.wasm

clean:
	rm -f *.o *.wasm *.log *.a *.so