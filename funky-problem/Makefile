include ../lib/common.mk.inc

CFLAGS+=-fPIC

SIDE_LDFLAGS+=-shared

all: main

main: main.o libside.so
	$(CXX) main.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@

lib%.so: %.o
	$(CXX) $< $(LDFLAGS) $(SIDE_LDFLAGS) -o $@
