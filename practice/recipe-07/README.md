### Find模块的使用

系统中提供了其他各种模块，一般情况需要使用include指令显式的调用，
`find_package`指令是一个特例，可以直接调用预定义的模块。

以依赖curl库为例，我们需要添加curl的头文件路径和库文件。有两种方法：

方法1：  
直接通过`include_directories`和`target_link_libraries`指令添加：
我们可以直接在CMakeLists.txt中添加：
```
include_directories(/usr/include)
target_link_libraries(curltest curl)
```
然后建立build目录进行外部构建即可。

方法2：   
使用FindCURL模块。
向CMakeLists.txt中添加：
```
find_package(CURL)
if(CURL_FOUND)
    include_directories(${CURL_INCLUDE_DIR})
    target_link_libraries(curltest ${CURL_LIBRARY})
else()
    message(FATAL_ERROR ”CURL library not found”)
endif()
```

对于系统预定义的`Find<name>.cmake`模块，使用方法一般如上例所示：
每一个模块都会定义以下几个变量
- `<name>_FOUND`
- `<name>_INCLUDE_DIR` or `<name>_INCLUDES`
- `<name>_LIBRARY` or `<name>_LIBRARIES`
你可以通过`<name>_FOUND`来判断模块是否被找到，如果没有找到，
按照工程的需要关闭某些特性、给出提醒或者中止编译，上面的例子就是报出致命错误并终止构建。
如果`<name>_FOUND`为真，则将`<name>_INCLUDE_DIR`加入`include_directories`，
将`<name>_LIBRARY`加入`target_link_libraries`中。

我们再来看一个复杂的例子，通过`<name>_FOUND`来控制工程特性：
```
set(mySources viewer.c)
set(optionalSources)
set(optionalLibs)

find_package(JPEG)
if(JPEG_FOUND)
    set(optionalSources ${optionalSources} jpegview.c)
    include_directories( ${JPEG_INCLUDE_DIR} )
    set(optionalLibs ${optionalLibs} ${JPEG_LIBRARIES} )
    add_definitions(-DENABLE_JPEG_SUPPORT)
endif()

find_package(PNG)
if(PNG_FOUND)
    set(optionalSources ${optionalSources} pngview.c)
    include_directories( ${PNG_INCLUDE_DIR} )
    set(optionalLibs ${optionalLibs} ${PNG_LIBRARIES} )
    add_definitions(-DENABLE_PNG_SUPPORT)
endif()

add_executable(viewer ${mySources} ${optionalSources} )
target_link_libraries(viewer ${optionalLibs}
```
通过判断系统是否提供了JPEG库来决定程序是否支持JPEG功能。

#### 项目构建

编译项目通过如下命令完成：

```shell
$ mkdir build
$ cd build
$ cmake ..
$ cmake --build .
```

或者采用更简单的方式

```shell
$ cmake -H. -Bbuild
$ cmake --build build
```

