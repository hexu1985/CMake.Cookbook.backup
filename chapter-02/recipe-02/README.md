### 2.2 处理与平台相关的源代码

`target_compile_definitions()`指令：  
为目标增加编译定义。

通过定义以下目标编译定义，让预处理器知道系统名称
```
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    target_compile_definitions(hello-world PUBLIC "IS_LINUX")
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    target_compile_definitions(hello-world PUBLIC "IS_MACOS")
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    target_compile_definitions(hello-world PUBLIC "IS_WINDOWS")
endif()
```

可以使用 `add_definitions(-DIS_LINUX)` 来设置定义(当然，可以根据平台调整定义)，
而不是使用 `target_compile_definition` 。
使用 add_definitions 的缺点是， 会修改编译整个项目的定义，
而 `target_compile_definitions` 给我们机会，将定义限制于一个特定的目标，
以及通过 PRIVATE|PUBLIC|INTERFACE 限定符，限制这些定义可见性。
