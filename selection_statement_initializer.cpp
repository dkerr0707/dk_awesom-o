#include <map>
#include <iostream>
#include <vector>

int main() {
    std::vector<int> v {1, 2, 3, 4};
    std::cout << "v size " << v.size() << std::endl;

    std::map<int, std::string> m{{3, "bling"}, {7, "tang"}, {10, "tong"}};
    m.emplace(4, "bar");
    m.insert({1, "foo"});

    std::cout << m.size() << std::endl;
    
//    auto it = m.find(4);
    if (auto it = m.find(4); it != m.end()) {
        // Structured Binidings
        auto [id, name] = *it;
        std::cout << "Found - " << id << " " << name << std::endl;
    }
    else {
        std::cout << "Not Found" << std::endl;
    }
}
