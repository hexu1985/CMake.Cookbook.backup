### 1.1 将单个源文件编译为可执行文件

首先创建一个项目目录，然后把源文件和CMakeLists.txt放入项目目录

CMakeLists.txt包含如下内容

```cmake
cmake_minimum_required(VERSION 3.5 FATAL_ERROR) # 设置CMake所需的最低版本。如果使用的CMake版本低于该版本，则会
发出致命错误：
project(recipe-01 LANGUAGES CXX) # 声明了项目的名称( recipe-01 )和支持的编程语言(CXX代表C++)：
add_executable(hello-world hello-world.cpp) # 指示CMake创建一个新目标：可执行文件 hello-world 。这个可执行文件是通
过编译和链接源文件 hello-world.cpp 生成的
```

编译项目通过如下命令完成：

```shell
$ mkdir build
$ cd build
$ cmake ..
$ cmake --build .
```

或者采用更简单的方式

```shell
$ cmake -Bbuild -H.
$ cmake --build build/
```
