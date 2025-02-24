#include "../include/triangle.h"
#include "test_base.h"

TEST_F(BaseTest, TriangleTypeTest) {
    std::cout << "[TEST] Running TriangleTypeTest...\n";
    EXPECT_EQ(triangleType(3, 4, 5), "Scalene");
    EXPECT_EQ(triangleType(2, 2, 3), "Isosceles");
    EXPECT_EQ(triangleType(1, 1, 1), "Equilateral");
    EXPECT_EQ(triangleType(0, 1, 1), "Not a triangle");
    EXPECT_EQ(triangleType(1, 1, 1), "Not a triangle");   // Failure case
}