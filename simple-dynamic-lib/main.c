#include <assert.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <stdio.h>

int main() {
	void* handle = dlopen("libside.so", RTLD_NOW);
	if (!handle) {
		printf("dlopen failed: %s\n", dlerror());
		return 1;
	}
	int (*get_value)() = (int (*)())dlsym(handle, "get_value");
	if (!get_value) {
		printf("dlsym failed: %s\n", dlerror());
		return 1;
	}
	int value = get_value();
	printf("The dynamic library returned: %d\n", value);
	assert(value == 42);
	exit(0);
}