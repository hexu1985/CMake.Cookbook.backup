### 3.1 检测Python解释器

`find_package` 是用于发现和设置包的CMake模块的命令。
这些模块包含CMake命令，用于标识系统标准位置中的包。
CMake模块文件称为 `Find<name>.cmake` ，当调用 `find_package(<name>)` 时，
模块中的命令将会运行。

除了在系统上实际查找包模块之外，查找模块还会设置了一些有用的变量，
反映实际找到了什么，也可以在自己的 CMakeLists.txt 中使用这些变量。

对于Python解释器，相关模块为 FindPythonInterp.cmake 附带的设置了一些CMake变量:
- `PYTHONINTERP_FOUND`：是否找到解释器
- `PYTHON_EXECUTABLE`：Python解释器到可执行文件的路径
- `PYTHON_VERSION_STRING`：Python解释器的完整版本信息
- `PYTHON_VERSION_MAJOR`：Python解释器的主要版本号
- `PYTHON_VERSION_MINOR`：Python解释器的次要版本号
- `PYTHON_VERSION_PATCH`：Python解释器的补丁版本号

使用 find_package 命令找到Python解释器，示例如下：
```
find_package(PythonInterp REQUIRED)

execute_process(
    COMMAND
    ${PYTHON_EXECUTABLE} "-c" "print('Hello, world!')"
    RESULT_VARIABLE _status
    OUTPUT_VARIABLE _hello_world
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    )

message(STATUS "RESULT_VARIABLE is: ${_status}")
message(STATUS "OUTPUT_VARIABLE is: ${_hello_world}")
```

可以强制CMake，查找特定版本的包。
例如，要求Python解释器的版本大于或等于2.7： 
```
find_package(PythonInterp 2.7)
```

软件包没有安装在标准位置时，CMake无法正确定位它们。用户可以使用CLI的 `-D` 参数传递相应的选项，
告诉CMake查看特定的位置。Python解释器可以使用以下配置:
```
$ cmake -D PYTHON_EXECUTABLE=/custom/location/python ..
```
这将指定非标准 /custom/location/pytho 安装目录中的Python可执行文件。

