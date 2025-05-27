include ../lib/common.mk.inc

all: main

main: main.o other.o
	$(CXX) main.o other.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@
