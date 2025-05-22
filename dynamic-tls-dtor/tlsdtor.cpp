#include <iostream>

struct Item {
    ~Item() { std::cout << "tls dtor fired\n"; }
};

thread_local Item tls_item;

extern "C" void use_tls() {
    (void)tls_item;
}
