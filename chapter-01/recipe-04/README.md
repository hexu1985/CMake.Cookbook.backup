### 1.4 用条件句控制编译

CMake中通过 set()命令设置变量
```
set(USE_LIBRARY OFF)
message(STATUS "Compile sources into a library? ${USE_LIBRARY}")
```

条件结构 `if-else- else-endif` 的使用
```
if(USE_LIBRARY)
    # add_library will create a static library
    # since BUILD_SHARED_LIBS is OFF
    add_library(message ${_sources})
    add_executable(hello-world hello-world.cpp)
    target_link_libraries(hello-world message)
else()
    add_executable(hello-world hello-world.cpp ${_sources})
endif()
```

如CMake语言文档中描述，逻辑真或假可以用多种方式表示：
- 如果将逻辑变量设置为以下任意一种： `1` 、 `ON` 、 `YES` 、 `true` 、 `Y` 或`非零数`，则逻辑变量为 true 。
- 如果将逻辑变量设置为以下任意一种： `0` 、 `OFF` 、 `NO` 、 `false` 、 `N` 、 `IGNORE`、`NOTFOUND` 、`空字符串`，或者以 `-NOTFOUND` 为后缀，则逻辑变量为 false 。
  
**BUILD_SHARED_LIBS**   
是CMake的一个全局标志。因为CMake内部要查询 `BUILD_SHARED_LIBS` 全局变量，所以 `add_library` 命令可以在不传递 STATIC/SHARED/OBJECT 参数的情况下调用；
如果为 false 或未定义，将生成一个静态库。


