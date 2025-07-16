
WASMER?=wasmer
CC ?= cc
CXX ?= c++
LD ?= cc

%.o: %.cpp Makefile
	$(CXX) $(CFLAGS) -c $< -o $@

main.wasm: main.o Makefile
	$(LD) $(LDFLAGS) -o $@ main.o

%.wasm: %.o Makefile
	$(LD) $(LDFLAGS) -o $@ $<

clean:
	rm -f *.o *.wasm *.log *.a *.so
