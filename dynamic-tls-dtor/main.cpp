#include <dlfcn.h>
#include <thread>
#include <iostream>

int main() {
    void* handle = dlopen("./libtlsdtor.so", RTLD_NOW);
    if (!handle) {
        std::cerr << "dlopen failed: " << dlerror() << std::endl;
        return 1;
    }

    using func_t = void (*)();
    auto use_tls = (func_t)dlsym(handle, "use_tls");
    if (!use_tls) {
        std::cerr << "dlsym failed: " << dlerror() << std::endl;
        return 1;
    }

    std::thread t([&]{ use_tls(); });
    t.join();

    dlclose(handle);
    return 0;
}
