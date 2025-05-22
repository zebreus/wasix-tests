include ../lib/common.mk.inc

CFLAGS += -pthread
LDFLAGS += -pthread

all: main

main: main.o
	$(CXX) main.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@
