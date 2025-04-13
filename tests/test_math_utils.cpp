#include "../include/math_utils.h"
#include "test_base.h"

// Instead of having three separate tests, let's combine them into one test with clear sections
TEST_F(BaseTest, MathUtilsTest) {
    TEST_NAME("MathUtilsTest");
    TEST_CASE("Basic addition tests");
    EXPECT_EQ_TRACKED(5, add(2, 3), "2 + 3 should equal 5");
    EXPECT_EQ_TRACKED(0, add(-1, 1), "-1 + 1 should equal 0");
    EXPECT_EQ_TRACKED(0, add(0, 0), "0 + 0 should equal 0");

    TEST_CASE("Basic multiplication tests");
    EXPECT_EQ_TRACKED(6, multiply(2, 3), "2 * 3 should equal 6");
    EXPECT_EQ_TRACKED(-6, multiply(-2, 3), "-2 * 3 should equal -6");
    EXPECT_EQ_TRACKED(0, multiply(0, 10), "0 * 10 should equal 0");

    // Deliberate failures to demonstrate how they're reported
    TEST_CASE("Tests with deliberate failures");
    EXPECT_EQ_TRACKED(10, add(3, 3), "This will fail: 3 + 3 should equal 10");
    EXPECT_EQ_TRACKED(5, multiply(2, 2), "This will fail: 2 * 2 should equal 5");
}
