# GoogleTest_Practice
> ABOUT: SWE course google test practice here

## Table of Contents
- [GoogleTest\_Practice](#googletest_practice)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Installation](#installation)
  - [Create a new test](#create-a-new-test)

## Description
This repository is a practice for Google Test, a C++ testing framework. It includes various test cases and examples to help understand how to write and run tests using Google Test.

## Installation
To install Google Test, follow these steps:
1. Install CMake and a C++ compiler | [🔗Cmake](https://cmake.org/download/) [🔗GCC](https://gcc.gnu.org/)
2. Clone the repository:
```bash
git clone https://github.com/mehedi37/GoogleTest_Practice.git
cd GoogleTest_Practice
```
3. Run the specific `run` script:
```bash
./run.sh # for Linux
run.bat # for Windows
```

## Create a new test
1. Create a new header file in the `include` directory:
```cpp
// include/your_module.h
#ifndef YOUR_MODULE_H
#define YOUR_MODULE_H

// Your declarations here
class YourClass {
public:
    // Your public methods
private:
    // Your private members
};

#endif // YOUR_MODULE_H
```

2. Implement your module in the `src` directory:
```cpp
// src/your_module.cpp
#include "../include/your_module.h"

// Your implementation here
```

3. Create a test file in the `tests` directory:
```cpp
// tests/test_your_module.cpp
#include <gtest/gtest.h>
#include "../include/your_module.h"
#include "test_base.h"

TEST_F(BaseTest, YourTest) {
    // Your test implementation
    std::cout << "[TEST] Running YourTest...\n";
    // EXPECT_EQ(actual, expected);
    // ASSERT_TRUE(condition);
}
```

4. Update the CMake files:
   - Add your implementation to `src/CMakeLists.txt`:
   ```cmake
   add_library(MyLibrary
       math_utils.cpp
       your_module.cpp  # Add this line
   )
   ```
   - Add your test to `tests/CMakeLists.txt`:
   ```cmake
   add_executable(RunTests
       test_math_utils.cpp
       test_your_module.cpp  # Add this line
   )
   ```

5. Build and run tests:
```bash
./run.sh  # Linux
run.bat   # Windows
```
