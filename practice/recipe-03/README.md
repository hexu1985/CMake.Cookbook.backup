### 静态库与动态库构建

#### 指令简介

add_library指令的语法是：
```
add_library(libname [SHARED|STATIC|MODULE]
        [EXCLUDE_FROM_ALL]
        source1 source2 ... sourceN)
```
类型有三种:
- SHARED，动态库
- STATIC，静态库
- MODULE，在使用dyld的系统有效，如果不支持dyld，则被当作SHARED对待。

EXCLUDE_FROM_ALL参数的意思是这个库不会被默认构建，除非有其他的组件依赖或者手
工构建。

具体例子如下：
```
add_library(hello SHARED hello.c)
```
这个指令指定将hello.c编译一个动态库，在linux下为libhello.so（windows下为hello.dll）。

如果你要是定libhello.so生成的位置，可以通过在主工程文件CMakeLists.txt中
修改add_subdirectory(lib <路径>)指令来指定一个编译输出位置
或者在lib/CMakeLists.txt中添加set(LIBRARY_OUTPUT_PATH <路径>)来指定一个新的位置。


**添加静态库**：

因为hello作为一个target是不能重名的，所以我们需要用类似命名指定：
```
add_library(hello_static STATIC hello.c)
```
这个指令会构建一个libhello_static.a的静态库（linux下）。


set_target_properties指令的语法是：
```
set_target_properties(target1 target2 ...
        PROPERTIES prop1 value1
        prop2 value2 ...)
```
这条指令可以用来设置输出的名称，对于动态库，还可以用来指定动态库版本和API版本。

例如我们想把hello_static这个target的对应的静态库名改成hello，即在linux为libhello.a，
可以使用如下指令：
```
set_target_properties(hello_static PROPERTIES OUTPUT_NAME "hello")
```

get_target_property指令的语法是：
```
get_target_property(VAR target property)
```

具体例子如下：
```
get_target_property(OUTPUT_VALUE hello_static OUTPUT_NAME)
message(STATUS “This is the hello_static OUTPUT_NAME:”${OUTPUT_VALUE})
```
如果没有这个属性定义，则返回NOTFOUND.

**动态库版本号**

按照规则，动态库是应该包含一个版本号的，
为了实现动态库版本号，我们仍然需要使用set_target_properties指令。
具体使用方法如下：
```
set_target_properties(hello PROPERTIES VERSION 1.2 SOVERSION 1)
```
VERSION指代动态库版本，SOVERSION指代API版本。

**安装共享库和头文件**

通过install指令安装库和头文件的例子如下：
```
install(TARGETS hello hello_static
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)
install(FILES hello.h DESTINATION include/hello)
```
注意，静态库要使用ARCHIVE关键字


#### 项目构建

编译项目通过如下命令完成：

```shell
$ mkdir build
$ cd build
$ cmake -DCMAKE_INSTALL_PREFIX=/tmp/t3/usr ..
$ cmake --build . --target install
```

或者采用更简单的方式

```shell
$ cmake -H. -Bbuild -DCMAKE_INSTALL_PREFIX=/tmp/t3/usr
$ cmake --build build/ --target install
```

linux环境下也可以通过make install来安装：

```shell
$ mdkir build
$ cd build
$ cmake -DCMAKE_INSTALL_PREFIX=/tmp/t3/usr ..
$ make
$ make install
```

