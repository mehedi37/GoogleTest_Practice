#ifndef TEST_BASE_H
#define TEST_BASE_H

#include <gtest/gtest.h>
#include <iostream>
#include <string>

// Cross-platform terminal colors using ANSI escape codes
namespace Colors {
    // Basic colors
    const char* const RED = "\033[31m";
    const char* const GREEN = "\033[32m";
    const char* const YELLOW = "\033[33m";
    const char* const BLUE = "\033[34m";
    const char* const MAGENTA = "\033[35m";
    const char* const CYAN = "\033[36m";
    const char* const WHITE = "\033[37m";

    // Bright/bold colors
    const char* const BRED = "\033[1;31m";
    const char* const BGREEN = "\033[1;32m";
    const char* const BYELLOW = "\033[1;33m";
    const char* const BBLUE = "\033[1;34m";
    const char* const BMAGENTA = "\033[1;35m";
    const char* const BCYAN = "\033[1;36m";
    const char* const BWHITE = "\033[1;37m";

    // Reset to default
    const char* const RESET = "\033[0m";

    // Special formatting
    const char* const BOLD = "\033[1m";
    const char* const UNDERLINE = "\033[4m";

    // Test status colors
    const char* const PASS = BGREEN;
    const char* const FAIL = BRED;
    const char* const INFO = BCYAN;
    const char* const HEADER = BYELLOW;
    const char* const SECTION = BMAGENTA;
}

// Base test class with improved debugging features
class BaseTest : public ::testing::Test {
protected:
    // Counters for assertions
    int passedAssertions = 0;
    int failedAssertions = 0;

    void SetUp() override {
        const ::testing::TestInfo* const test_info =
            ::testing::UnitTest::GetInstance()->current_test_info();
        std::cout << "\n" << Colors::INFO << "[SETUP] " << Colors::RESET
                  << "Starting test: " << Colors::BOLD << test_info->test_suite_name()
                  << "." << test_info->name() << Colors::RESET << "\n";

        // Reset counters for this test
        passedAssertions = 0;
        failedAssertions = 0;
    }

    void TearDown() override {
        const ::testing::TestInfo* const test_info =
            ::testing::UnitTest::GetInstance()->current_test_info();
        std::cout << Colors::INFO << "[TEARDOWN] " << Colors::RESET
                  << "Finished test: " << Colors::HEADER << Colors::BOLD << test_info->name() << Colors::RESET << "\n";

        // Report assertion counts
        std::cout << Colors::INFO << "[ASSERTIONS] " << Colors::RESET
                  << "Passed: " << Colors::GREEN << passedAssertions << Colors::RESET
                  << ", Failed: " << (failedAssertions > 0 ? Colors::RED : Colors::RESET)
                  << failedAssertions << Colors::RESET << "\n";

        // Report test status
        if(::testing::UnitTest::GetInstance()->current_test_info()->result()->Passed()) {
            std::cout << Colors::PASS << "[PASSED] " << Colors::RESET
                      << Colors::HEADER << Colors::BOLD << test_info->name() << Colors::RESET
                      << " Test passed successfully\n\n";
        } else {
            std::cout << Colors::FAIL << "[FAILED] " << Colors::RESET
                      << Colors::BOLD << test_info->name() << Colors::RESET
                      << " Test failed\n\n";
        }
    }

    // Helper methods for test cases
    void beginTestCase(const std::string& description) {
        std::cout << "\n" << Colors::SECTION << ">> [TEST CASE] "
                  << Colors::RESET << description << "\n";
    }

    void setTestName(const std::string& name) {
        std::cout << "\n" << Colors::HEADER
                  << "=======================================================" << Colors::RESET << "\n";
        std::cout << Colors::HEADER << "\t\t[TEST NAME] " << Colors::BOLD << name << Colors::RESET;
        std::cout << "\n" << Colors::HEADER
                  << "=======================================================" << Colors::RESET << "\n";
    }

    // Assertion wrappers that track results
    template<typename T, typename U>
    ::testing::AssertionResult expectEqual(const T& expected, const U& actual, const char* message = "") {
        auto result = ::testing::internal::EqHelper::Compare(
            "expected", "actual", expected, actual);

        if (result) {
            passedAssertions++;
            std::cout << Colors::PASS << "[PASS] " << Colors::RESET << message << (message[0] ? " - " : "")
                      << "Expected: " << Colors::GREEN << expected << Colors::RESET
                      << ", Actual: " << Colors::GREEN << actual << Colors::RESET << "\n";
        } else {
            failedAssertions++;
            std::cout << Colors::FAIL << "[FAIL] " << Colors::RESET << message << (message[0] ? " - " : "")
                      << "Expected: " << Colors::GREEN << expected << Colors::RESET
                      << ", Actual: " << Colors::RED << actual << Colors::RESET << "\n";
        }

        return result;
    }

    template<typename T>
    ::testing::AssertionResult expectTrue(const T& condition, const char* message = "") {
        if (condition) {
            passedAssertions++;
            std::cout << Colors::PASS << "[PASS] " << Colors::RESET << message << "\n";
            return ::testing::AssertionSuccess();
        } else {
            failedAssertions++;
            std::cout << Colors::FAIL << "[FAIL] " << Colors::RESET << message << "\n";
            return ::testing::AssertionFailure();
        }
    }

    template<typename T>
    ::testing::AssertionResult expectFalse(const T& condition, const char* message = "") {
        if (!condition) {
            passedAssertions++;
            std::cout << Colors::PASS << "[PASS] " << Colors::RESET << message << "\n";
            return ::testing::AssertionSuccess();
        } else {
            failedAssertions++;
            std::cout << Colors::FAIL << "[FAIL] " << Colors::RESET << message << "\n";
            return ::testing::AssertionFailure();
        }
    }
};

// Macros to simplify test code
#define TEST_CASE(description) beginTestCase(description)
#define TEST_NAME(name) setTestName(name)
#define EXPECT_EQ_TRACKED(expected, actual, message) EXPECT_TRUE(expectEqual(expected, actual, message))
#define EXPECT_TRUE_TRACKED(condition, message) EXPECT_TRUE(expectTrue(condition, message))
#define EXPECT_FALSE_TRACKED(condition, message) EXPECT_TRUE(expectFalse(condition, message))

// Shorthand for creating test cases
#define CREATE_TEST(test_suite_name, test_name) \
    TEST_F(test_suite_name, test_name)

#endif // TEST_BASE_H
