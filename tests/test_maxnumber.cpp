#include "../include/maxnumber.h"
#include "test_base.h"

TEST_F(BaseTest, FindMaxNumber) {
  TEST_NAME("FindMaxNumber");
  TEST_CASE("Positive numbers");
  EXPECT_EQ_TRACKED(maxnumber(1, 2, 3), "3 is the largest number", "Max of 1, 2, 3 should be 3");

  TEST_CASE("Negative numbers");
  EXPECT_EQ_TRACKED(maxnumber(-1, -2, -3), "-1 is the largest number", "Max of -1, -2, -3 should be -1");
}