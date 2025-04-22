#ifndef INCLUDE_LIBRARY_H_
#define INCLUDE_LIBRARY_H_
#include <bits/stdc++.h>

using namespace std;

class Book {
 public:
     string isbn;
     string title;
     string author;
};

class Library {
 public:
     vector<Book> books;
     bool addBook(string title, string author, string isbn);
     bool removeBook(string ISBN);
     bool findBook(string ISBN);
};

#endif  // INCLUDE_LIBRARY_H_
