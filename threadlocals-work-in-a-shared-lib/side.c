#include <stdio.h>

_Thread_local int toast = 10;
void print_and_increment_toast() {
    printf("value=%d ", toast++);
}