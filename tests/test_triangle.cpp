#include "../include/triangle.h"
#include "test_base.h"

TEST_F(BaseTest, TriangleTypeTest) {
    TEST_NAME("TriangleTypeTest");
    TEST_CASE("Valid triangles");
    EXPECT_EQ_TRACKED("Scalene", triangleType(3, 4, 5), "3-4-5 should be a scalene triangle");
    EXPECT_EQ_TRACKED("Isosceles", triangleType(2, 2, 3), "2-2-3 should be an isosceles triangle");
    EXPECT_EQ_TRACKED("Equilateral", triangleType(1, 1, 1), "1-1-1 should be an equilateral triangle");

    TEST_CASE("Invalid triangles");
    EXPECT_EQ_TRACKED("Not a triangle", triangleType(0, 1, 1), "0-1-1 should not be a triangle");
    EXPECT_EQ_TRACKED("Not a triangle", triangleType(1, 2, 3), "1-2-3 should not be a triangle");
    EXPECT_EQ_TRACKED("Not a triangle", triangleType(-1, 2, 3), "Negative values should not be a triangle");
}