#ifndef TEST_BASE_H
#define TEST_BASE_H

#include <gtest/gtest.h>
#include <iostream>
#include <string>

// Base test class with improved debugging features
class BaseTest : public ::testing::Test {
protected:
    // Counters for assertions
    int passedAssertions = 0;
    int failedAssertions = 0;

    void SetUp() override {
        const ::testing::TestInfo* const test_info =
            ::testing::UnitTest::GetInstance()->current_test_info();
        std::cout << "\n[SETUP] Starting test: "
                  << test_info->test_suite_name() << "." << test_info->name() << "\n";

        // Reset counters for this test
        passedAssertions = 0;
        failedAssertions = 0;
    }

    void TearDown() override {
        const ::testing::TestInfo* const test_info =
            ::testing::UnitTest::GetInstance()->current_test_info();
        std::cout << "[TEARDOWN] Finished test: "
                  << test_info->name() << "\n";

        // Report assertion counts
        std::cout << "[ASSERTIONS] Passed: " << passedAssertions
                  << ", Failed: " << failedAssertions << "\n";

        // Report test status
        if(::testing::UnitTest::GetInstance()->current_test_info()->result()->Passed()) {
            std::cout << "[PASSED] " << test_info->name() << " Test passed successfully\n\n";
        } else {
            std::cout << "[FAILED] " << test_info->name() << " Test failed\n\n";
        }
    }

    // Helper methods for test cases
    void beginTestCase(const std::string& description) {
        std::cout << "\n>> [TEST CASE] " << description << "\n";
    }

    void setTestName(const std::string& name) {
        std::cout << "\n====================================================\n";
        std::cout << "\t\t[TEST NAME] " << name;
        std::cout << "\n====================================================\n";
    }

    // Assertion wrappers that track results
    template<typename T, typename U>
    ::testing::AssertionResult expectEqual(const T& expected, const U& actual, const char* message = "") {
        auto result = ::testing::internal::EqHelper::Compare(
            "expected", "actual", expected, actual);

        if (result) {
            passedAssertions++;
            std::cout << "[PASS] " << message << (message[0] ? " - " : "")
                      << "Expected: " << expected << ", Actual: " << actual << "\n";
        } else {
            failedAssertions++;
            std::cout << "[FAIL] " << message << (message[0] ? " - " : "")
                      << "Expected: " << expected << ", Actual: " << actual << "\n";
        }

        return result;
    }

    template<typename T>
    ::testing::AssertionResult expectTrue(const T& condition, const char* message = "") {
        if (condition) {
            passedAssertions++;
            std::cout << "[PASS] " << message << "\n";
            return ::testing::AssertionSuccess();
        } else {
            failedAssertions++;
            std::cout << "[FAIL] " << message << "\n";
            return ::testing::AssertionFailure();
        }
    }

    template<typename T>
    ::testing::AssertionResult expectFalse(const T& condition, const char* message = "") {
        if (!condition) {
            passedAssertions++;
            std::cout << "[PASS] " << message << "\n";
            return ::testing::AssertionSuccess();
        } else {
            failedAssertions++;
            std::cout << "[FAIL] " << message << "\n";
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
