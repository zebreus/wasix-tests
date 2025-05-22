#include <iostream>

struct Item {
    ~Item() { std::cout << "tls dtor fired\n"; }
};

extern "C" {
    thread_local Item tls_item;
    void use_tls();
}

thread_local Item tls_item;
void use_tls() {
    (void)tls_item;
}
