include ../lib/common.mk.inc

CFLAGS+=-fPIC -pthread
LDFLAGS+=-pthread

MAIN_LDFLAGS+=-L$(shell pwd)
MAIN_LDFLAGS+=-lside

SIDE_LDFLAGS+=-shared
SECONDARY: side.o main.o
all: main

main: main.o libside.so
	$(CXX) main.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@

lib%.so: %.o
	$(CXX) $< $(LDFLAGS) $(SIDE_LDFLAGS) -o $@