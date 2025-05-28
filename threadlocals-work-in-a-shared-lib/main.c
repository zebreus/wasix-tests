#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <pthread.h>

extern _Thread_local int toast = 10;
extern void print_and_increment_toast();

void *thread_func(void *data) {
    print_and_increment_toast();
    return NULL;
}

int main()
{
    print_and_increment_toast();
    print_and_increment_toast();
    toast = 20;
    print_and_increment_toast();

    pthread_attr_t attr = {0};
    if (pthread_attr_init(&attr) != 0) {
        perror("init attr");
        return -1;
    }
    pthread_t thread = {0};
    if (pthread_create(&thread, &attr, &thread_func, (void *)stdout) != 0) {
        perror("create thread");
        return -1;
    }
    void *thread_ret;
    if (pthread_join(thread, &thread_ret) != 0) {
        perror("join");
        return -1;
    }

    print_and_increment_toast();
    return 0;
}