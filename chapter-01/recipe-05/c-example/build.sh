#!/usr/bin/env bash

cmake -DCMAKE_BUILD_TYPE=Debug -H. -Bbuild
cmake --build build
