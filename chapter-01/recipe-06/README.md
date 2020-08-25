### 1.6 指定编译器

CMake可以根据平台和生成器选择编译器，还能将编译器标志设置为默认值。

CMake将语言的编译器存储在 `CMAKE_<LANG>_COMPILER` 变量中，其中 `<LANG>` 是受支持的任何一种语言，例如 `CXX` 、 `C` 或 `Fortran` 。

用户可以通过以下两种方式之一设置此变量：
1. 使用CLI中的 -D 选项，例如：
    ```
    $ cmake -D CMAKE_CXX_COMPILER=clang++ ..
    ```
2. 通过导出环境变量 CXX (C++编译器)、 CC (C编译器)和 FC (Fortran编译器)。
   例如，使用这个命令使用 clang++ 作为 C++ 编译器：
    ```
    $ env CXX=clang++ cmake ..
    ```

我们的平台上的CMake，在哪里可以找到可用的编译器和编译器标志？  
CMake提供 `--system-information` 标志，它将把关于系统的所有信息转储到屏幕或文件中。要查看这个信息，请尝试以下操作：
```
$ cmake --system-information information.txt
```
如果不加文件名，信息将会输出到屏幕上。


CMake提供了额外的变量来与编译器交互：
- `CMAKE_<LANG>_COMPILER_LOADED`：如果为项目启用了语言 `<LANG>` ，则将设置为 TRUE 。
- `CMAKE_<LANG>_COMPILER_ID` ：编译器标识字符串，编译器供应商所特有。例如， GCC 用于GNU编译器集合， AppleClang 用于macOS上的Clang,
    MSVC 用于Microsoft Visual Studio编译器。注意，不能保证为所有编译器或语言定义此变量。
- `CMAKE_COMPILER_IS_GNU<LANG>`：如果语言 `<LANG>` 是GNU编译器集合的一部分，则将此逻辑变量设置为 TRUE 。
    注意变量名的 `<LANG>` 部分遵循GNU约定：C语言为 CC , C++语言为 CXX , Fortran语言为 G77 。
- `CMAKE_<LANG>_COMPILER_VERSION`：此变量包含一个字符串，该字符串给定语言的编译器版本。版本信息在 `major[.minor[.patch[.tweak]]]` 中给出。
    但是，对于 `CMAKE_<LANG>_COMPILER_ID` ，不能保证所有编译器或语言都定义了此变量。

使用CMake变量来探索已使用的编译器(及版本)的示例如下：
```
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(recipe-06 LANGUAGES C CXX)

message(STATUS "Is the C++ compiler loaded? ${CMAKE_CXX_COMPILER_LOADED}")
if(CMAKE_CXX_COMPILER_LOADED)
    message(STATUS "The C++ compiler ID is: ${CMAKE_CXX_COMPILER_ID}")
    message(STATUS "Is the C++ from GNU? ${CMAKE_COMPILER_IS_GNUCXX}")
    message(STATUS "The C++ compiler version is: ${CMAKE_CXX_COMPILER_VERSION}")
endif()

message(STATUS "Is the C compiler loaded? ${CMAKE_C_COMPILER_LOADED}")
if(CMAKE_C_COMPILER_LOADED)
    message(STATUS "The C compiler ID is: ${CMAKE_C_COMPILER_ID}")
    message(STATUS "Is the C from GNU? ${CMAKE_COMPILER_IS_GNUCC}")
    message(STATUS "The C compiler version is: ${CMAKE_C_COMPILER_VERSION}")
endif()
```

