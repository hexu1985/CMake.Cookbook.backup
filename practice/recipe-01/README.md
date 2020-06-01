### 初试cmake – cmake的helloworld

如果你需要看到make构建的详细过程，可以使用`make VERBOSE=1或者VERBOSE=1 make命令来进行构建。
windows系统上通过`VERBOSE=1 cmake --build .`

#### 指令简介

project指令的语法是：
```
project(projectname [CXX] [C] [Java])
```
你可以用这个指令定义工程名称，并可指定工程支持的语言，支持的语言列表是可以忽略的，默认情况表示支持所有语言。
这个指令隐式的定义了两个cmake变量: <projectname>_BINARY_DIR以及<projectname>_SOURCE_DIR。
同时cmake系统也帮助我们预定义了PROJECT_BINARY_DIR和PROJECT_SOURCE_DIR变量，
他们的值分别跟<projectname>_BINARY_DIR以及<projectname>_SOURCE_DIR一致。

set指令的语法是：
```
set(VAR [VALUE] [CACHE TYPE DOCSTRING [FORCE]])
```

message指令的语法是：
```
message([SEND_ERROR | STATUS | FATAL_ERROR] "message to display" ...)
```
这个指令用于向终端输出用户定义的信息，包含了三种类型:
- SEND_ERROR，产生错误，生成过程被跳过。
- SATUS，输出前缀为—的信息。
- FATAL_ERROR，立即终止所有cmake过程.

add_executable指令说明：
```
add_executable(hello ${SRC_LIST})
```
定义了这个工程会生成一个文件名为hello的可执行文件，相关的源文件是SRC_LIST中定义的源文件列表

#### 基本语法规则

1. 变量使用${}方式取值，但是在IF控制语句中是直接使用变量名
2. 指令(参数1 参数2...)：参数使用括弧括起，参数之间使用空格或分号分开。
3. 指令是大小写无关的，参数和变量是大小写相关的。

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
$ cmake -Bbuild -H.
$ cmake --build build/
```

