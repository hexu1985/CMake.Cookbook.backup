rm -rf ./build
cmake -DCMAKE_INSTALL_PREFIX=./install -Bbuild -H. 
#cmake -G"MSYS Makefiles" -Bbuild -H. 
cmake --build build/ --target install
