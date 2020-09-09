### 2.4 检测处理器体系结构

CMake的 `CMAKE_SIZEOF_VOID_P` 变量会告诉我们CPU是32位还是64位。
我们通过状态消息让用户知道检测到的大小，并设置预处理器定义:
```
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    target_compile_definitions(arch-dependent PUBLIC "IS_64_BIT_ARCH")
    message(STATUS "Target is 64 bits")
else()
    target_compile_definitions(arch-dependent PUBLIC "IS_32_BIT_ARCH")
    message(STATUS "Target is 32 bits")
endif()
```

CMake定义了 `CMAKE_HOST_SYSTEM_PROCESSOR` 变量，以包含当前运行的处理器的名称。
可以设置为“i386”、“i686”、“x86_64”、“AMD64”等等，当然，这取决于当前的CPU。

通过定义以下目标编译定义，让预处理器了解主机处理器架构，同时在配置过程中打印状态消息:
```
if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "i386")
    message(STATUS "i386 architecture detected")
elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "i686")
    message(STATUS "i686 architecture detected")
elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "x86_64")
    message(STATUS "x86_64 architecture detected")
else()
    message(STATUS "host processor architecture is unknown")
endif()
target_compile_definitions(arch-dependent PUBLIC "ARCHITECTURE=${CMAKE_HOST_SYSTEM_PROCESSOR}")
```


