### 1.9 为语言设定标准

编程语言有不同的标准，即提供改进的语言版本。启用新标准是通过设置适当的编译器标志来实现的。
3.1版本中，CMake引入了一个独立于平台和编译器的机制，用于为 C++ 和 C 设置语言标准：为目标设置 `<LANG>_STANDARD` 属性，包括：
- `CXX_STANDARD`会设置我们想要的标准。
- `CXX_EXTENSIONS`告诉CMake，只启用 ISO C++ 标准的编译器标志，而不使用特定编译器的扩展。
- `CXX_STANDARD_REQUIRED`指定所选标准的版本。如果这个版本不可用， CMake将停止配置并出现错误。
    当这个属性被设置为 OFF 时，CMake将寻找下一个标准的最新版本，直到一个合适的标志。
    这意味着，首先查找 C++14 ，然后是 C++11 ，然后是 C++98 。

为目标设置 `CXX_STANDARD` 、 `CXX_EXTENSIONS` 和 `CXX_STANDARD_REQUIRED` 属性示例如下：
```
set_target_properties(animals
    PROPERTIES
    CXX_STANDARD 14
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    POSITION_INDEPENDENT_CODE 1
    )
```

如果语言标准是所有目标共享的全局属性，那么可以将 `CMAKE_<LANG>_STANDARD` 、 `CMAKE_<LANG>_EXTENSIONS` 和 
`CMAKE_<LANG>_STANDARD_REQUIRED` 变量设置为相应的值。所有目标上的对应属性都将使用这些设置。例如：
```
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
```
