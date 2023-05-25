#include <iostream>
#include <string>

extern "C" void printString(const char* str) {
    std::cout << "C++ received string: " << str << std::endl;
}



