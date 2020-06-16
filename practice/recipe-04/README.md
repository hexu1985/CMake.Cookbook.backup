### 使用外部共享库和头文件

#### 指令简介

include_directories指令的语法是：
```
include_directories([AFTER|BEFORE] [SYSTEM] dir1 dir2 ...)
```
这条指令可以用来向工程添加多个特定的头文件搜索路径，路径之间用空格分割，如果路径
中包含了空格，可以使用双引号将它括起来，默认的行为是追加到当前的头文件搜索路径的
后面，你可以通过两种方式来进行控制搜索路径添加的方式：
1. CMAKE_INCLUDE_DIRECTORIES_BEFORE，通过set这个cmake变量为ON，可以将添加的头文件搜索路径放在已有路径的前面。
2. 通过AFTER或者BEFORE参数，也可以控制是追加还是置前。

具体例子如下：
```
include_directories(/usr/include/hello)
```

另外：我们也可以通过target_include_directories来为指定的target添加头文件搜索路径。

link_directories指令的语法：
```
link_directories(directory1 directory2 ...)
```
这个指令非常简单，添加非标准的共享库搜索路径，比如，在工程内部同时存在共享库和可
执行二进制，在编译时就需要指定一下这些共享库的路径。

另外：我们也可以通过target_link_directories来为指定的target添加库搜索路径。

target_link_libraries指令的语法：
```
target_link_libraries(target library1
        <debug | optimized> library2
        ...)
```
这个指令可以用来为target添加需要链接的共享库，target可以是一个可执行文件，
但是同样可以用于为自己编写的共享库添加共享库链接。

具体例子如下：
```
target_link_libraries(main hello)
```
也可以写成
```
target_link_libraries(main libhello.so)
```

由于相同路径下存在同libname的共享库和静态库的情况下，link会优先链接动态库，
所以想要链接静态库的话，方法如下：
```
target_link_libraries(main libhello.a)
```

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


