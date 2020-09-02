### 1.8 设置编译器选项

CMake为调整或扩展编译器标志提供了很大的灵活性，您可以选择下面两种方法：
- CMake将编译选项视为目标属性。因此，可以根据每个目标设置编译选项，而不需要覆盖CMake默认值。
- 可以使用 -D CLI标志直接修改 `CMAKE_<LANG>_FLAGS_<CONFIG>` 变量。这将影响项目中的所有目标，并覆盖或扩展CMake默认值。

目标设置属性通过`target_compile_options()`命令完成，例如：
```
list(APPEND flags "-fPIC" "-Wall")
if(NOT WIN32)
    list(APPEND flags "-Wextra" "-Wpedantic")
endif()

add_library(geometry
    STATIC
    geometry_circle.cpp
    geometry_circle.hpp
    geometry_polygon.cpp
    geometry_polygon.hpp
    geometry_rhombus.cpp
    geometry_rhombus.hpp
    geometry_square.cpp
    geometry_square.hpp
    )

target_compile_options(geometry 
    PRIVATE
    ${flags}
    )
```

编译选项可以添加三个级别的可见性： INTERFACE 、 PUBLIC 和 PRIVATE 。
可见性的含义如下:
- `PRIVATE`，编译选项会应用于给定的目标，不会传递给与目标相关的目标。
- `INTERFACE`，给定的编译选项将只应用于指定目标，并传递给与目标相关的目标。
- `PUBLIC`，编译选项将应用于指定目标和使用它的目标。

控制编译器标志的第二种方法，不用对 CMakeLists.txt 进行修改。
可以使用CMake参数进行配置，例如：
```
$ cmake -D CMAKE_CXX_FLAGS="-fno-exceptions -fno-rtti" ..
```
