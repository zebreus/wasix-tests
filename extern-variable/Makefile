include ../lib/common.mk.inc

all: main

main: main.o erryes.o
	$(CXX) main.o erryes.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@