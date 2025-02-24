#!/bin/bash

rm -rf ~/GTEST/.build
mkdir ~/GTEST/.build
cd ~/GTEST/.build
cmake ..
make
# ctest
cd ~/GTEST/.build/tests/
./RunTests
