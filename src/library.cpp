#include "../include/library.h"
#include <bits/stdc++.h>

using namespace std;

bool Library::addBook(string title, string author, string isbn) {
    Book book;
    book.title = title;
    book.author = author;
    book.isbn = isbn;
    books.push_back(book);
    return true;
}

bool Library::removeBook(string ISBN) {
    for (auto it = books.begin(); it != books.end(); ++it) {
        if (it->isbn == ISBN) {
            books.erase(it);
            return true;
        }
    }
    return false;
}

bool Library::findBook(string ISBN) {
    for (const auto& book : books) {
        if (book.isbn == ISBN) {
            cout << "Book found: " << book.title << " by " << book.author << endl;
            return true;
        }
    }
    cout << "Book not found (ISBN: " << ISBN << ")" << endl;
    return false;
}
