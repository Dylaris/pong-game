#!/bin/sh

set -xe

gcc -Wall -Wextra                           \
    -I./raylib-5.5_linux_amd64/include      \
    -o main main.c                          \
    -L./raylib-5.5_linux_amd64/lib -lraylib \
    -Wl,-rpath=./raylib-5.5_linux_amd64/lib
