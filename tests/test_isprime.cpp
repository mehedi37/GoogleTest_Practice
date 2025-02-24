#include "../include/isprime.h"
#include "test_base.h"

TEST_F(BaseTest, TestIsPrime) {
    EXPECT_TRUE(isprime(2));
    EXPECT_TRUE(isprime(3));
    EXPECT_FALSE(isprime(4));
    EXPECT_TRUE(isprime(5));
    EXPECT_FALSE(isprime(6));
    EXPECT_TRUE(isprime(7));
    EXPECT_FALSE(isprime(8));
    EXPECT_FALSE(isprime(9));
    EXPECT_FALSE(isprime(10));
    EXPECT_TRUE(isprime(11));
}