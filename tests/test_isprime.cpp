#include "../include/isprime.h"
#include "test_base.h"

TEST_F(BaseTest, TestIsPrime) {
    TEST_NAME("TestIsPrime");
    TEST_CASE("Small prime numbers");
    EXPECT_TRUE_TRACKED(isprime(2), "2 should be prime");
    EXPECT_TRUE_TRACKED(isprime(3), "3 should be prime");
    EXPECT_FALSE_TRACKED(isprime(4), "4 should not be prime");

    TEST_CASE("Medium prime numbers");
    EXPECT_TRUE_TRACKED(isprime(6), "6 should be prime");
    EXPECT_FALSE_TRACKED(isprime(6), "6 should not be prime");
    EXPECT_TRUE_TRACKED(isprime(7), "7 should be prime");
    EXPECT_FALSE_TRACKED(isprime(8), "8 should not be prime");
    EXPECT_FALSE_TRACKED(isprime(9), "9 should not be prime");

    TEST_CASE("Larger prime numbers");
    EXPECT_FALSE_TRACKED(isprime(10), "10 should not be prime");
    EXPECT_TRUE_TRACKED(isprime(11), "11 should be prime");
}