#include <assert.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <stdio.h>

__attribute__((__weak__)) extern int other_func();

int main() {
	if (!other_func) {
		printf("success: other_func is NULL, which is expected\n");
		exit(0);
	}
	printf("failure: other_func should be NULL\n");
	exit(1);
}