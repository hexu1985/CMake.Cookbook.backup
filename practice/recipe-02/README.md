### 初试cmake – cmake的helloworld

#### 指令简介

add_subdirectory指令的语法是：
```
add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
```
这个指令用于向当前工程添加存放源文件的子目录，并可以指定中间二进制和目标二进制存放的位置。EXCLUDE_FROM_ALL参数的含义是将这个目录从编译过程中排除，比如，工程的example，可能就需要工程构建完成后，再进入example目录单独进行构建(当然，你也可以通过定义依赖来解决此类问题)。

**换个地方保存目标二进制**：

除了add_subdirectory指令(不论是否指定编译输出目录)，我们还可以通过set指令重新定义EXECUTABLE_OUTPUT_PATH和LIBRARY_OUTPUT_PATH变量来指定最终的目标二进制的位置(指最终生成的hello或者最终的共享库，不包含编译生成的中间文件)
```
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
```

**cmake应该如何实现make install**：

这里需要引入一个新的cmake 指令 install和一个非常有用的变量CMAKE_INSTALL_PREFIX。
CMAKE_INSTALL_PREFIX变量类似于configure脚本的 –prefix，常见的使用方法看起来是这个样子：
```
cmake -DCMAKE_INSTALL_PREFIX=/usr .
```
install指令用于定义安装规则，安装的内容可以包括目标二进制、动态库、静态库以及 文件、目录、脚本等。 

install指令 -- 目标文件的安装：
```
install(TARGETS targets...
        [[ARCHIVE|LIBRARY|RUNTIME]
            [DESTINATION <dir>]
            [PERMISSIONS permissions...]
            [CONFIGURATIONS [Debug|Release|...]]
            [COMPONENT <component>]
            [OPTIONAL]
        ] [...])
```
参数中的TARGETS后面跟的就是我们通过add_executable或者add_library定义的目标文件，可能是可执行二进制、动态库、静态库。

目标类型也就相对应的有三种：
- ARCHIVE特指静态库
- LIBRARY特指动态库
- RUNTIME特指可执行目标二进制。

DESTINATION定义了安装的路径，如果路径以/开头，那么指的是绝对路径，这时候CMAKE_INSTALL_PREFIX其实就无效了。如果你希望使用CMAKE_INSTALL_PREFIX来定义安装路径，就要写成相对路径，即不要以/开头，那么安装后的路径就是`${CMAKE_INSTALL_PREFIX}/<DESTINATION定义的路径>`

举个简单的例子：
```
install(TARGETS myrun mylib mystaticlib
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION libstatic
       )
```
上面的例子会将：  
可执行二进制myrun安装到`${CMAKE_INSTALL_PREFIX}/bin`目录，  
动态库libmylib安装到`${CMAKE_INSTALL_PREFIX}/lib`目录，  
静态库libmystaticlib安装到`${CMAKE_INSTALL_PREFIX}/libstatic`目录。

install指令 -- 普通文件的安装：
```
install(FILES files... DESTINATION <dir>
        [PERMISSIONS permissions...]
        [CONFIGURATIONS [Debug|Release|...]]
        [COMPONENT <component>]
        [RENAME <name>] [OPTIONAL])
```
可用于安装一般文件，并可以指定访问权限，文件名是此指令所在路径下的相对路径。如果默认不定义权限PERMISSIONS，安装后的权限为：
OWNER_WRITE, OWNER_READ, GROUP_READ,和WORLD_READ，即644权限。

install指令 -- 非目标文件的可执行程序安装(比如脚本之类)：
```
install(PROGRAMS files... DESTINATION <dir>
        [PERMISSIONS permissions...]
        [CONFIGURATIONS [Debug|Release|...]]
        [COMPONENT <component>]
        [RENAME <name>] [OPTIONAL])
```
跟上面的FILES指令使用方法一样，唯一的不同是安装后权限为：
OWNER_EXECUTE, GROUP_EXECUTE, 和WORLD_EXECUTE，即755权限

install指令 -- 目录的安装：
```
install(DIRECTORY dirs... DESTINATION <dir>
        [FILE_PERMISSIONS permissions...]
        [DIRECTORY_PERMISSIONS permissions...]
        [USE_SOURCE_PERMISSIONS]
        [CONFIGURATIONS [Debug|Release|...]]
        [COMPONENT <component>]
        [[PATTERN <pattern> | REGEX <regex>]
        [EXCLUDE] [PERMISSIONS permissions...]] [...])
```
这里主要介绍其中的DIRECTORY、PATTERN以及PERMISSIONS参数。
DIRECTORY后面连接的是所在Source目录的相对路径，但务必注意：
abc和abc/有很大的区别。
如果目录名不以/结尾，那么这个目录将被安装为目标路径下的abc，如果目录名以/结尾，
代表将这个目录中的内容安装到目标路径，但不包括这个目录本身。
PATTERN用于使用正则表达式进行过滤，PERMISSIONS用于指定PATTERN过滤后的文件权限。

我们来看一个例子：
```
install(DIRECTORY icons scripts/ DESTINATION share/myproj
        PATTERN "CVS" EXCLUDE
        PATTERN "scripts/*"
        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ
        GROUP_EXECUTE GROUP_READ)
```
这条指令的执行结果是：
将icons目录安装到`<prefix>/share/myproj`，将scripts/中的内容安装到`<prefix>/share/myproj`
不包含目录名为CVS的目录，对于scripts/*文件指定权限为 `WNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ。

安装时CMAKE脚本的执行：
```
install([[SCRIPT <file>] [CODE <code>]] [...])
```
SCRIPT参数用于在安装时调用cmake脚本文件（也就是<abc>.cmake文件）
CODE参数用于执行CMAKE指令，必须以双引号括起来。比如：
```
install(CODE "MESSAGE(\"Sample install message.\")")
```


#### 项目构建

编译项目通过如下命令完成：

```shell
$ mkdir build
$ cd build
$ cmake -DCMAKE_INSTALL_PREFIX=/tmp/t2/usr ..
$ cmake --build . --target install
```

或者采用更简单的方式

```shell
$ cmake -DCMAKE_INSTALL_PREFIX=/tmp/t2/usr -Bbuild -H.
$ cmake --build build/ --target install
```

linux环境下也可以通过make install来安装：

```shell
$ mdkir build
$ cd build
$ cmake -DCMAKE_INSTALL_PREFIX=/tmp/t2/usr ..
$ make
$ make install
```

