### 1.3 构建和链接静态库和动态库
  
#### 创建和链接静态库

创建和链接静态库，需要如下步骤：

1. 创建目标——静态库。库的名称和源码文件名相同，具体代码如下：

```cmake
add_library(message
		STATIC
		Message.hpp
		Message.cpp
		)
```

2. 创建 hello-world 可执行文件的目标部分不需要修改：

```cmake
add_executable(hello-world hello-world.cpp)
```

3. 将目标库链接到可执行目标：

```cmake
target_link_libraries(hello-world message)
``` 

#### add_library指令

add_library(message STATIC Message.hpp Message.cpp) ：生成必要的构建指令，将指定的源码编译到库中。 
add_library 的第一个参数是目标名。整个 CMakeLists.txt 中，可使用相同的名称来引用库。
生成的库的实际名称将由CMake通过在前面添加前缀 lib 和适当的扩展名作为后缀来形成。
生成库是根据第二个参数( STATIC 或 SHARED )和操作系统确定的。add_library常用的库类型有：

- **STATIC**：用于创建静态库，即编译文件的打包存档，以便在链接其他目标时使用，例如：可执行文件。

- **SHARED**：用于创建动态库，即可以动态链接，并在运行时加载的库。可以在 CMakeLists.txt 中使用 add_library(message SHARED Message.hpp Message.cpp) 从静态库切换到动态共享对象(DSO)。

- **OBJECT**：可将给定 add_library 的列表中的源码编译到目标文件，不将它们归档到静态库中，也不能将它们链接到共享对象中。如果需要一次性创建静态库和动态库，那么使用对象库尤其有用。我们将在本示例中演示。

- **MODULE**：又为DSO组。与 SHARED 库不同，它们不链接到项目中的任何目标，不过可以进行动态加载。该参数可以用于构建运行时插件。

CMake还能够生成特殊类型的库，这不会在构建系统中产生输出，但是对于组织目标之间的依赖关系，和构建需求非常有用：

- **IMPORTED**：此类库目标表示位于项目外部的库。此类库的主要用途是，对现有依赖项进行构建。因此， IMPORTED 库将被视为不可变的。

- **INTERFACE**：与 IMPORTED 库类似。不过，该类型库可变，没有位置信息。它主要用于项目之外的目标构建使用。

- **ALIAS**：顾名思义，这种库为项目中已存在的库目标定义别名。不过，不能为 IMPORTED 库选择别名。

#### OBJECT 库的使用

OBJECT 库的使用，需要修改 CMakeLists.txt ，如下：

```cmake
add_library(message-objs
		OBJECT
		Message.hpp
		Message.cpp
		)

# this is only needed for older compilers
# but doesn't hurt either to have it
set_target_properties(message-objs
		PROPERTIES
		POSITION_INDEPENDENT_CODE 1
		)

add_library(message-shared
		SHARED
		$<TARGET_OBJECTS:message-objs>
		)

add_library(message-static
		STATIC
		$<TARGET_OBJECTS:message-objs>
		)

add_executable(hello-world hello-world.cpp)
target_link_libraries(hello-world message-static)
```

1. 首先， add_library 改为 add_library(Message-objs OBJECT Message.hppMessage.cpp) 。

2. 此外，需要保证编译的目标文件与生成位置无关。可以通过使用 set_target_properties 命令，设置 message-objs 目标的相应属性来实现。

3. 现在，可以使用这个对象库来获取静态库( message-static )和动态库( messageshared)。
要注意引用对象库的生成器表达式语法: `$<TARGET_OBJECTS:messageobjs>`。生成器表达式是CMake在生成时(即配置之后)构造，用于生成特定于配置的构建输出。

