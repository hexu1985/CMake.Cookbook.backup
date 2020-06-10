### cmake常用变量和常用环境变量

#### cmake变量引用的方式：

使用`${}`进行变量的引用。在IF等语句中，是直接使用变量名而不通过`${}`取值

#### cmake自定义变量的方式：

主要有隐式定义和显式定义两种，前面举了一个隐式定义的例子，就是project指令，
他会隐式的定义`<projectname>_BINARY_DIR`和`<projectname>_SOURCE_DIR`两个变量。

显式定义的例子我们前面也提到了，使用set指令，就可以构建一个自定义变量了。

比如:
```
set(HELLO_SRC main.c)
```
就可以通过`${HELLO_SRC}`来引用这个自定义变量了.

#### cmake常用变量：

1. `CMAKE_BINARY_DIR`，`PROJECT_BINARY_DIR`，`<projectname>_BINARY_DIR`
    这三个变量指代的内容是一致的，指的是工程编译发生的目录。

2. `CMAKE_SOURCE_DIR`，`PROJECT_SOURCE_DIR`，`<projectname>_SOURCE_DIR`
    这三个变量指代的内容是一致的，都是工程顶层目录。

3. `CMAKE_CURRENT_SOURCE_DIR`
    指的是当前处理的CMakeLists.txt所在的路径。

4. `CMAKE_CURRRENT_BINARY_DIR`
    他指的是target编译目录。
    使用我们上面提到的add_subdirectory(src bin)可以更改这个变量的值。
    使用set(EXECUTABLE_OUTPUT_PATH <新路径>)并不会对这个变量造成影响，
    它仅仅修改了最终目标文件存放的路径。

5. `CMAKE_CURRENT_LIST_FILE`
    输出调用这个变量的CMakeLists.txt的完整路径

6. `CMAKE_CURRENT_LIST_LINE`
    输出这个变量所在的行

7. `CMAKE_MODULE_PATH`
    这个变量用来定义自己的cmake模块所在的路径。如果你的工程比较复杂，
    有可能会自己编写一些cmake模块，这些cmake模块是随你的工程发布的，
    为了让cmake在处理CMakeLists.txt时找到这些模块，你需要通过SET指令，
    将自己的cmake模块路径设置一下。
    比如：
    ```
    set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
    ```
    这时候你就可以通过include指令来调用自己的模块了。

8. `EXECUTABLE_OUTPUT_PATH`和`LIBRARY_OUTPUT_PATH`
    分别用来重新定义最终结果的存放目录。

9. `PROJECT_NAME`
    返回通过project指令定义的项目名称。

10. `CMAKE_INCLUDE_CURRENT_DIR`
    自动添加CMAKE_CURRENT_BINARY_DIR和CMAKE_CURRENT_SOURCE_DIR到当前处理的CMakeLists.txt。
    相当于在每个CMakeLists.txt加入：
    ```
    include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
    ```
    该选项模式是关闭的，可以通过如下命令打开：
    ```
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
    ```

11. `CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE`
    将工程提供的头文件目录始终至于系统头文件目录的前面，当你定义的头文件确实跟系统发
    生冲突时可以提供一些帮助。

12. `CMAKE_INCLUDE_PATH`
    为find_file()和find_path()指令指定搜索路径，默认为空。例如：
    ```
    set(CMAKE_INCLUDE_PATH /usr/include/hello)
    find_path(myHeader hello.h)
    if(myHeader)
        include_directories(${myHeader})
    endif(myHeader)
    ```

13. `CMAKE_LIBRARY_PATH`
    为find_library()指令指定搜索路径，默认为空。

#### 系统信息

1. `CMAKE_MAJOR_VERSION`，CMAKE主版本号，比如2.4.6中的2
2. `CMAKE_MINOR_VERSION`，CMAKE次版本号，比如2.4.6中的4
3. `CMAKE_PATCH_VERSION`，CMAKE补丁等级，比如2.4.6 中的6
4. `CMAKE_SYSTEM`，系统名称，比如Linux-2.6.22
5. `CMAKE_SYSTEM_NAME`，不包含版本的系统名，比如Linux
6. `CMAKE_SYSTEM_VERSION`，系统版本，比如2.6.22
7. `CMAKE_SYSTEM_PROCESSOR`，处理器名称，比如i686.
8. `UNIX`，在所有的类UNIX平台为TRUE，包括OS X和cygwin
9. `WIN32`，在所有的win32平台为TRUE，包括cygwin

#### 主要的开关选项：

1. `BUILD_SHARED_LIBS`
    这个开关用来控制默认的库编译方式，如果不进行设置，
    使用add_library并没有指定库类型的情况下，默认编译生成的库都是静态库。
    如果`set(BUILD_SHARED_LIBS ON)`后，默认生成的为动态库。

2. `CMAKE_C_FLAGS`
    设置C编译选项，也可以通过指令add_definitions()添加。

3. `CMAKE_CXX_FLAGS`
    设置C++编译选项，也可以通过指令add_definitions()添加。

#### cmake调用环境变量的方式

使用`$ENV{NAME}`指令就可以调用系统的环境变量了。
比如：
```
message(STATUS "HOME dir: $ENV{HOME}")
```
设置环境变量的方式是：
```
set(ENV{变量名} 值)
```

