include ../lib/common.mk.inc

CFLAGS+=-fPIC -pthread
LDFLAGS+=-pthread

SIDE_LDFLAGS+=-shared

all: main

main: main.o
	$(CXX) main.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@