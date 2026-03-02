#include <iostream>
#include <optional>

int main() {
    std::optional<std::string> greeting("Tudo Bem?");
    std::cout << greeting.value_or("empty") << std::endl;

    if (greeting.has_value()) {
        std::cout << "Has Value - " << greeting.value() << std::endl;
    }
}
