
WASMER?=wasmer
CC ?= cc
CXX ?= c++
LD ?= cc


%.o: %.cpp Makefile
	$(CXX) $(CFLAGS) -c $< -o $@

main.wasm: main.o erryes.o Makefile
	$(LD) $(LDFLAGS) -o $@ main.o erryes.o

run: main.wasm
	$(WASMER) run main.wasm

clean:
	rm -f *.o *.wasm *.log *.a *.so