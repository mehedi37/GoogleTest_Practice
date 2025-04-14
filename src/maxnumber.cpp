#include "../include/maxnumber.h"
#include<string>
using namespace std;


string maxnumber(int a, int b, int c) {
  if (a > b && a > c) {
    return to_string(a) + " is the largest number";
  } else if (b > a && b > c) {
    return to_string(b) + " is the largest number";
  } else {
    return to_string(c) + " is the largest number";
  }
}