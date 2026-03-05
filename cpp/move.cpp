#include <utility>
#include <string>
#include <iostream>
#include <vector>

int main() {
    std::string s0;
    std::string s1 = "Ola";
    std::string s2 = std::move(s1);
    std::cout << s0.empty() << " - " << s1 << " - " << s2 << std::endl;
    printf("Hello");    

    std::vector<float> data(1<<20, 7);
    std::vector<float> new_data = std::move(data);
    std::cout << data.size() << " " << new_data.size() << std::endl;
}
