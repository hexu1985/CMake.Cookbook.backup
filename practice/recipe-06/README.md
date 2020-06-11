### cmake常用指令

#### 基本指令

1. `add_definitions`
    向C/C++编译器添加-D定义，比如:
    ```
    add_definitions(-DENABLE_DEBUG -DABC)
    ```
    参数之间用空格分割。
    如果你的代码中定义了
    ```
    #ifdef ENABLE_DEBUG 
        // ...
    #endif
    ```
    这个代码块就会生效。
    如果要添加其他的编译器开关，可以通过`CMAKE_C_FLAGS`变量和`CMAKE_CXX_FLAGS`变量设置。

2. `add_dependencies`
    定义target依赖的其他target，确保在编译本target之前，其他的target已经被构建。
    具体语法：
    ```
    add_dependencies(target-name depend-target1
                    depend-target2 ...)
    ```

3. [`add_executable`](../recipe-01/README.md)、
    [`add_library`](../recipe-03/README.md)、
    [`add_subdirectory`](../recipe-02/README.md)
    前面已经介绍过了，这里不再罗唆。

4. `add_test`与`enable_testing`指令。
    `enable_testing`指令用来控制Makefile是否构建test目标，涉及工程所有目录。
    语法很简单，没有任何参数，
    ```
    enable_testing()
    ```
    一般情况这个指令放在工程的主CMakeLists.txt中。

    `add_test`指令的语法是:
    ```
    add_test(testname Exename arg1 arg2 ...)
    ```
    testname是自定义的test名称，Exename可以是构建的目标文件也可以是外部脚本等等。
    后面连接传递给可执行文件的参数。如果没有在同一个CMakeLists.txt中打开
    enable_testing()指令，任何add_test都是无效的。
    具体例子如下：
    ```
    enable_testing()
    add_test(mytest ${PROJECT_BINARY_DIR}/bin/main)
    ```
    生成Makefile后，就可以在构建目录下，运行make test来执行测试了，或者执行ctest。

5. `aux_source_directory`
    基本语法是：
    ```
    aux_source_directory(dir VARIABLE)
    ```
    作用是发现一个目录下所有的源代码文件并将列表存储在一个变量中，
    这个指令临时被用来自动构建源文件列表。因为目前cmake还不能自动发现新添加的源文件。
    比如：
    ```
    aux_source_directory(. SRC_LIST)
    add_executable(main ${SRC_LIST})
    ```
    你也可以通过后面提到的foreach指令来处理这个LIST

6. `cmake_minimum_required`
    其语法为
    ```
    cmake_minimum_required(VERSION versionNumber [FATAL_ERROR])
    ```
    比如：
    ```
    cmake_minimum_required(VERSION 2.5 FATAL_ERROR)
    ```
    如果cmake版本小与2.5，则出现严重错误，整个过程中止。

7. `exec_program`
    在CMakeLists.txt处理过程中执行命令，并不会在生成的Makefile中执行。
    具体语法为：
    ```
    exec_program(Executable [directory in which to run]
                [ARGS <arguments to executable>]
                [OUTPUT_VARIABLE <var>]
                [RETURN_VALUE <var>])
    ```
    用于在指定的目录运行某个程序，通过ARGS添加参数，如果要获取输出和返回值，
    可通过OUTPUT_VARIABLE和RETURN_VALUE分别定义两个变量。
    这个指令可以帮助你在CMakeLists.txt处理过程中支持任何命令，
    比如根据系统情况去修改代码文件等等。

    举个简单的例子，我们要在src目录执行ls命令，并把结果和返回值存下来。
    可以直接在src/CMakeLists.txt中添加：
    ```
    exec_program(ls ARGS "*.c" OUTPUT_VARIABLE LS_OUTPUT RETURN_VALUE LS_RVALUE)
    if(not LS_RVALUE)
        message(STATUS "ls result: " ${LS_OUTPUT})
    endif(not LS_RVALUE)
    ```
    在cmake 生成Makefile的过程中，就会执行ls命令，如果返回0，则说明成功执行，
    那么就输出ls *.c的结果。关于IF语句，后面的控制指令会提到。

8. `include`指令
    用来载入CMakeLists.txt文件，也用于载入预定义的cmake模块.
    ```
    include(file [OPTIONAL])
    include(module [OPTIONAL])
    ```
    OPTIONAL参数的作用是文件不存在也不会产生错误。
    你可以指定载入一个文件，如果定义的是一个模块，那么将在CMAKE_MODULE_PATH中搜索这个模块并载入。
    载入的内容将在处理到INCLUDE语句是直接执行。

#### filesystem指令

1. `file(WRITE...)`和`file(APPEND...)`指令
    ```
    file(WRITE <filename> <content>...)
    file(APPEND <filename> <content>...)
    ```
    写入`<content>`到`<filename>`文件中。如果文件不存在则创建。
    如果文件已存在，WRITE 模式将覆盖内容，如果为 APPEND 模式将追加内容。任何在`<filename>`文件路径中的不存在文件夹都将被创建。
    例如：
    ```
    file(WRITE filename "message to write"... )
    file(APPEND filename "message to write"... )
    ```

2. `file(READ...)`指令
    ```
    file(READ <filename> <variable> 
            [OFFSET <offset>] [LIMIT <max-in>] [HEX])
    ```
    读取文件名为`<filename>`的文件并将其内容存储到`<variable>`变量中。
    可选的参数：`<offset>`指定起始读取位置，`<max-in>`最多读取字节数，HEX 将数据转为十六进制（处理二进制数据十分有用）。

3. `file(GLOB...)`和`file(GLOB_RECURSE...)`指令
    ```
    file(GLOB <variable>
            [LIST_DIRECTORIES true|false] [RELATIVE <path>] [CONFIGURE_DEPENDS]
            [<globbing-expressions>...])
    file(GLOB_RECURSE <variable> [FOLLOW_SYMLINKS]
            [LIST_DIRECTORIES true|false] [RELATIVE <path>] [CONFIGURE_DEPENDS]
            [<globbing-expressions>...])
    ```
    产生一个匹配`<globbing-expressions>`的文件列表并将它存储到变量`<variable>`中。
    文件名替代表达式和正则表达式相似，但更简单。如果 RELATIVE 标志位被设定，将返回指定路径的相对路径。结果将按字典顺序排序。
    如果 CONFIGURE_DEPENDS 标志位被指定，CMake 将在编译时给主构建系统添加逻辑来检查目标，以重新运行 GLOB 标志的命令。
    如果任何输出被改变，CMake都将重新生成这个构建系统。

    文件名替代表达式的使用示例如下：
    ```
    *.cxx      - 匹配所有后缀名为 cxx 的文件
    *.vt?      - 匹配所有后缀名为 vta,...,vtz 的文件
    f[3-5].txt - 匹配 f3.txt, f4.txt, f5.txt 文件
    ```
    GLOB_RECURSE 将会递归所有匹配文件夹的子文件夹和匹配的文件。
    子文件夹为符号链接时只有当 FOLLOW_SYMLINKS 被指定或规则 CMP0009 没有设置为 NEW 时才会被递归。

    默认 GLOB_RECURSE 省略结果列表中的目录，设置 LIST_DIRECTORIES 为 true 来添加目录到结果列表中。
    如果 FOLLOW_SYMLINKS 被指定或规则 CMP0009 没有设置为 OLD 。LIST_DIRECTORIES 将符号链接作为路径。

    递归文件名包括的例子：
    ```
    /dir/*.py  - match all python files in /dir and subdirectories
    ```

4. `file(REMOVE...)`和`file(REMOVE_RECURSE...)`指令
    ```
    file(REMOVE [<files>|<directories>...])
    file(REMOVE_RECURSE [<files>|<directories>...])
    ```
    删除指定文件或文件夹，REMOVE_RECURSE 模式将移动给定文件和文件夹，和非空文件夹。如果指定文件不存在不会给出错误。

5. `file(MAKE_DIRECTORY...)`指令
    ```
    file(MAKE_DIRECTORY [<directories>...])
    ```
    创建给定文件夹，并根据需求创建其父文件夹。

6. `file(RELATIVE_PATH...)`指令 
    ```
    file(RELATIVE_PATH <variable> <directory> <file>)
    ```
    计算文件`<file>`相对`<directory>`的相对路径并存储到`<viriable>`变量中。

7. `file(TO_CMAKE_PATH...)`和`file(TO_NATIVE_PATH...)`指令
    ```
    file(TO_CMAKE_PATH "<path>" <variable>)
    file(TO_NATIVE_PATH "<path>" <variable>)
    ```
    `<TO_CMAKE_PATH>`模式转换一个本地`<path>`为带 (/) 的 cmake 风格路径。输入可以是一个路径或系统搜索路径（如：`$ENV{PATH}`）。
    一个搜索路径可以被转换为以 : 分割的 cmake 风格列表。  
    `<TO_NATIVE_PATH>`模式转换一个 cmake 风格的`<path>`为一个本地路径，路径根据平台 \（windows 平台）或使用 / （其他平台）。  
    应总是使用双引号将将`<path>`括起来以保证它在此命令中作为单个参数对待。

#### [install指令](../recipe-02/README.md)

INSTALL系列指令已经在前面的章节有非常详细的说明，这里不在赘述，可参考前面的安装部分。

