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
	printf("c");
	dlclose(handle);
	printf("e");

	exit(0);
}

__attribute((constructor)) void MainConstructor(void) {
    printf("a");
}
__attribute((destructor)) void MainDestructor(void) {
    printf("f\n");
}