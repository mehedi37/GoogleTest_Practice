#include "../include/triangle.h"
#include <string>
using namespace std;

class Triangle {
 private:
    int a, b, c;
 public:
    Triangle(int a, int b, int c) : a(a), b(b), c(c) {}
    string type() {
        if (a <= 0 || b <= 0 || c <= 0) {
            return "Not a triangle";
        }
        if (a + b <= c || a + c <= b || b + c <= a) {
            return "Not a triangle";
        }
        if (a == b && b == c) {
            return "Equilateral";
        }
        if (a == b || a == c || b == c) {
            return "Isosceles";
        }
        return "Scalene";
    }
};

string triangleType(int a, int b, int c) {
    Triangle triangle(a, b, c);
    return triangle.type();
}