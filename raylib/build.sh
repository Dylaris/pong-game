#!/bin/sh

set -xe

gcc -Wall -Wextra -o main main.c $(pkg-config raylib --cflags --libs)
./main
