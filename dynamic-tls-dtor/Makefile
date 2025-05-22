include ../lib/common.mk.inc

MAIN_LDFLAGS += -L$(shell pwd)
MAIN_LDFLAGS += -ltlsdtor

# Position independent code needed for shared library with TLS
CFLAGS += -fPIC

TLS_LDFLAGS += -shared

all: main

main: main.o libtlsdtor.so
	$(CXX) main.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@

lib%.so: %.o
	$(CXX) $< $(LDFLAGS) $(TLS_LDFLAGS) -o $@
