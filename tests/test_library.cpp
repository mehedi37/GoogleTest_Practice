#include "../src/library.cpp"
#include "test_base.h"

TEST_F(BaseTest, LibraryOperations) {
    TEST_NAME("LibraryOperationsTest");
    Library library;

    TEST_NAME("AddBooks");
    EXPECT_TRUE_TRACKED(library.addBook("The Great Gatsby", "F. Scott Fitzgerald", "9780743273565"), "Add Book 1");
    EXPECT_TRUE_TRACKED(library.addBook("To Kill a Mockingbird", "Harper Lee", "9780061120084"), "Add Book 2");

    TEST_NAME("FindBooks");
    EXPECT_TRUE_TRACKED(library.findBook("9780743273565"), "Find Book (ISBN 9780743273565)");
    EXPECT_TRUE_TRACKED(library.findBook("97807432735651"), "Find Book (ISBN 97807432735651)");

    TEST_NAME("RemoveBooks");
    EXPECT_TRUE_TRACKED(library.removeBook("9780743273565"), "Remove Book (ISBN 9780743273565)");
}
