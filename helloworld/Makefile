
WASMER?=wasmer
CC ?= cc
CXX ?= c++
LD ?= cc

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c $< -o $@

%.wasm: %.o Makefile
	$(LD) $(LDFLAGS) -o $@ $<

clean:
	rm -f *.o *.wasm *.log *.a *.so