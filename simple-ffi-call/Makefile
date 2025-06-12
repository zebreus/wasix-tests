include ../lib/common.mk.inc

LDFLAGS+=-lffi

all: main

main: main.o
	$(CXX) main.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@