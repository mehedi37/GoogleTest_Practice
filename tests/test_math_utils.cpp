#include "math_utils.h"
#include "test_base.h"

// Test for add function
TEST_F(BaseTest, AddTest) {
    std::cout << "[TEST] Running AddTest...\n";
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(-1, 1), 0);
    EXPECT_EQ(add(0, 0), 0);
}

// Test for multiply function
TEST_F(BaseTest, MultiplyTest) {
    std::cout << "[TEST] Running MultiplyTest...\n";
    EXPECT_EQ(multiply(2, 3), 6);
    EXPECT_EQ(multiply(-2, 3), -6);
    EXPECT_EQ(multiply(0, 10), 0);
}
