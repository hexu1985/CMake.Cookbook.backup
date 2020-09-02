cmake -Bbuild -H. -DCMAKE_CXX_FLAGS="-fno-exceptions -fno-rtti"
cmake --build build -- VERBOSE=1
