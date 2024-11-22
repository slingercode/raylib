#!/bin/sh

cd external/raylib

mkdir -p build && cd build

cmake ..

cmake --build .
