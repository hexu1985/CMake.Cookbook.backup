### 1.1 将单个源文件编译为可执行文件

首先创建一个项目目录，然后把源文件和CMakeLists.txt放入项目目录

CMakeLists.txt包含如下内容

1. 设置CMake所需的最低版本。如果使用的CMake版本低于该版本，则会发出致命错误：

```cmake
cmake_minimum_required(VERSION 3.5 FATAL_ERROR) 
```

2. 声明了项目的名称( recipe-01 )和支持的编程语言(CXX代表C++)：

```cmake
project(recipe-01 LANGUAGES CXX) 
```

3. 指示CMake创建一个新目标：可执行文件 hello-world 。这个可执行文件是通过编译和链接源文件 hello-world.cpp 生成的。
CMake将为编译器使用默认设置，并自动选择生成工具：

```cmake
add_executable(hello-world hello-world.cpp) 
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

cmake命令支持--target <target-name>语法，实现如下功能

- all(或Visual Studio generator中的ALL_BUILD)是默认目标，将在项目中构建所有目标。
- clean，删除所有生成的文件。
- rebuild_cache，将调用CMake为源文件生成依赖(如果有的话)。
- edit_cache，这个目标允许直接编辑缓存。

对于更复杂的项目，通过测试阶段和安装规则，CMake将生成额外的目标：

- test(或Visual Studio generator中的RUN_TESTS)将在CTest的帮助下运行测试套件。
- install，将执行项目安装规则。
- package，此目标将调用CPack为项目生成可分发的包。
