### 1.5 向用户显示选项

CMake使用 `option()` 命令，以选项的形式显示逻辑开关，用于外部设置，从而切换构建系统的生成行为。
```
option(USE_LIBRARY "Compile sources into a library" OFF)
```

现在，可以通过CMake的 -D CLI选项，将信息传递给CMake来切换库的行为：
```
$ mkdir -p build
$ cd build
$ cmake -D USE_LIBRARY=ON ..
```

`-D` 开关用于为CMake设置任何类型的变量：逻辑变量、路径等等。

**option**
option 可接受三个参数：  
```
option(<option_variable> "help string" [initial value])
```
- `<option_variable>` 表示该选项的变量的名称。
- `"help string"` 记录选项的字符串，在CMake的终端或图形用户界面中可见。
- `[initial value]` 选项的默认值，可以是 `ON` 或 `OFF` 。

有时选项之间会有依赖的情况。CMake提供 `cmake_dependent_option()` 命令用来定义依赖于其他选项的选项：
```
include(CMakeDependentOption)
# second option depends on the value of the first
cmake_dependent_option(
    MAKE_STATIC_LIBRARY "Compile sources into a static library" OFF
    "USE_LIBRARY" ON
    )

# third option depends on the value of the first
cmake_dependent_option(
    MAKE_SHARED_LIBRARY "Compile sources into a shared library" ON
    "USE_LIBRARY" ON
    )
```
如果 `USE_LIBRARY` 为 ON ， `MAKE_STATIC_LIBRARY` 默认值为 OFF ，否则 `MAKE_SHARED_LIBRARY` 默认值为 ON 。
