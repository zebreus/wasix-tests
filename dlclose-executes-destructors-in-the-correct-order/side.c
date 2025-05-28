#include <stdio.h>

__attribute((constructor)) void ModuleConstructor(void) {
    printf("b");

}
__attribute((destructor)) void ModuleDestructor(void) {
    printf("d");
}