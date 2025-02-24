#ifndef TEST_BASE_H
#define TEST_BASE_H

#include <gtest/gtest.h>
#include <iostream>

// Base test class to be reused across multiple test files
class BaseTest : public ::testing::Test {
protected:
    void SetUp() override {
        std::cout << "\n[SETUP] Starting a new test...\n";
    }

    void TearDown() override {
        std::cout << "[TEARDOWN] Test finished.\n";
    }
};

#endif // TEST_BASE_H
