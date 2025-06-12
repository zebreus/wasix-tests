include ../lib/common.mk.inc

# Add -DFFI_CLOSURES=1 to enable closure support
CFLAGS+=-DFFI_CLOSURES=1
LDFLAGS+=-lffi

all: main

main: main.o
	$(CXX) main.o $(LDFLAGS) $(MAIN_LDFLAGS) -o $@
