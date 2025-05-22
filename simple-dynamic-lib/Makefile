CC ?= clang
CXX ?= clang++

# This is technically only required for the library

MAIN_LDFLAGS+=-L$(shell pwd)
MAIN_LDFLAGS+=-lside

SIDE_LDFLAGS+=-shared

all: libside.so main
main: libside.so

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.cpp Makefile
	$(CXX) $(CFLAGS) -c $< -o $@

main: main.o libside.so Makefile
	$(CXX) main.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@

lib%.so: %.o Makefile
	$(CXX) $< $(LDFLAGS) $(SIDE_LDFLAGS) -o $@

clean:
	rm -f *.o *.wasm *.log *.a *.so main