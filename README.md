# GoogleTest_Practice
> ABOUT: SWE course google test practice here

## Table of Contents
- [GoogleTest\_Practice](#googletest_practice)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Features](#features)
  - [Project Structure](#project-structure)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Create a new test](#create-a-new-test)
  - [Advanced Test Features](#advanced-test-features)

## Description
This repository is a practice for Google Test, a C++ testing framework. It includes various test cases and examples to help understand how to write and run tests using Google Test. The project demonstrates different testing techniques with multiple utility functions.

## Features
- Custom test base class with enhanced reporting
- Colorized test output in the terminal
- Automatic test discovery via CMake
- Cross-platform support (Linux/Windows)
- Multiple example modules:
  - `isprime`: Checks if a number is prime
  - `math_utils`: Basic arithmetic operations
  - `maxnumber`: Determines the largest of three numbers
  - `triangle`: Classifies triangles by their sides

## Project Structure
```
GoogleTest_Practice/
├── include/           # Header files for modules
├── src/               # Source implementations
├── tests/             # Test files for each module
├── libs/              # Third-party libraries (GoogleTest)
├── run.sh             # Script to build and run tests on Linux
└── run.bat            # Script to build and run tests on Windows
```

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

## Usage
The run scripts handle building and running tests automatically. You can also use filters to run specific tests:

```bash
# Linux examples
./run.sh                        # Run all tests
./run.sh --clean                # Clean build and run all tests
./run.sh --list                 # List all available tests
./run.sh "TriangleTypeTest.*"   # Run all tests in TriangleTypeTest
./run.sh --filter "*Type*"      # Run tests with 'Type' in their name

# Windows example
run.bat                         # Run all tests
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
    TEST_NAME("YourTest");
    TEST_CASE("Your test case description");

    // Use enhanced macros for better output
    EXPECT_EQ_TRACKED(expected, actual, "Description of test");
    EXPECT_TRUE_TRACKED(condition, "Condition should be true");
    EXPECT_FALSE_TRACKED(condition, "Condition should be false");
}
```

4. The build system will automatically discover and compile your new test files. No need to manually update CMakeLists.txt files as they use GLOB to find source files.

5. Build and run tests:
```bash
./run.sh  # Linux
run.bat   # Windows
```

## Advanced Test Features
This project includes a custom `BaseTest` class that enhances GoogleTest with:

- Colored terminal output for easier readability
- Detailed test reporting with pass/fail counts
- Test case grouping with descriptive messages
- Custom assertion macros for better error messages:
  - `EXPECT_EQ_TRACKED`: Enhanced equality assertions
  - `EXPECT_TRUE_TRACKED`: Enhanced boolean assertions
  - `EXPECT_FALSE_TRACKED`: Enhanced negative boolean assertions
  - `TEST_CASE`: Adds descriptive sections within tests
  - `TEST_NAME`: Sets a custom name for the test
