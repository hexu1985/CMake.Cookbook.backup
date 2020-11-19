### 3.3 检测Python模块和包

我们能够使用CMake检查NumPy是否可用。我们需要确保Python解释
器、头文件和库在系统上是可用的。然后，将再来确认NumPy的可用性：

0. 查找解释器、头文件和库的方法与前面的方法完全相同:
```
find_package(PythonInterp REQUIRED)
find_package(PythonLibs ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} EXACT REQUIRED)
```

1. 正确打包的Python模块，指定安装位置和版本。可以在 CMakeLists.txt 中执行Python脚本进行探测:
```
execute_process(
    COMMAND
        ${PYTHON_EXECUTABLE} "-c" "import re, numpy; print(re.compile('/__init__.py.*').sub('',numpy.__file__))"
    RESULT_VARIABLE _numpy_status
    OUTPUT_VARIABLE _numpy_location
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
```

2. 如果找到NumPy，则 `_numpy_status` 变量为整数，否则为错误的字符串，而 `_numpy_location` 将包含NumPy模块的路径。如果找到NumPy，则将它的位置保存到一个名为 NumPy 的新变量中。注意，新变量被缓存，这意味着CMake创建了一个持久性变量，用户稍后可以修改该变量:
```
if(NOT _numpy_status)
    set(NumPy ${_numpy_location} CACHE STRING "Location of NumPy")
endif()
```

3. 下一步是检查模块的版本。同样，我们在 CMakeLists.txt 中施加了一些Python魔法，将版本保存到 `_numpy_version` 变量中:
```
execute_process(
    COMMAND
        ${PYTHON_EXECUTABLE} "-c" "import numpy; print(numpy.__version__)"
    OUTPUT_VARIABLE _numpy_version
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )
```

4. 最后，FindPackageHandleStandardArgs 的CMake包以正确的格式设置 `NumPy_FOUND` 变量和输出信息:
```
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NumPy
    FOUND_VAR NumPy_FOUND
    REQUIRED_VARS NumPy
    VERSION_VAR _numpy_version
    )
```

5. 一旦正确的找到所有依赖项，我们就可以编译可执行文件，并将其链接到Python库:
```
add_executable(pure-embedding "")
target_sources(pure-embedding
    PRIVATE
        Py${PYTHON_VERSION_MAJOR}-pure-embedding.cpp
    )

target_include_directories(pure-embedding
    PRIVATE
        ${PYTHON_INCLUDE_DIRS}
    )

target_link_libraries(pure-embedding
    PRIVATE
        ${PYTHON_LIBRARIES}
    )
```

6. 我们还必须保证 use_numpy.py 在 build 目录中可用:
```
add_custom_command(
    OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/use_numpy.py
    COMMAND
        ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/use_numpy.py
        ${CMAKE_CURRENT_BINARY_DIR}/use_numpy.py
    DEPENDS
        ${CMAKE_CURRENT_SOURCE_DIR}/use_numpy.py
    )

# make sure building pure-embedding triggers the above custom command
target_sources(pure-embedding
    PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}/use_numpy.py
    )
```

例子中有三个新的CMake命令，需要 include(FindPackageHandleStandardArgs) ：
- execute_process
- add_custom_command
- find_package_handle_standard_args

execute_process 将作为通过子进程执行一个或多个命令。最后，子进程返回值将保存到变量作为参数，传递给 RESULT_VARIABLE ，而管道标准输出和标准错误的内容将被保存到变量作为参数传递给 OUTPUT_VARIABLE 和 ERROR_VARIABLE 。 execute_process 可以执行任何操作，并使用它们的结果来推断系统配置。本例中，用它来确保NumPy可用，然后获得模块版本。

find_package_handle_standard_args 提供了，用于处理与查找相关程序和库的标准工具。引用此命令时，可以正确的处理与版本相关的选项 ( REQUIRED 和 EXACT )，而无需更多的CMake代码。


