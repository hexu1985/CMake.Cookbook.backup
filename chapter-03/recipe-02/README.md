### 3.2 检测Python库

可以使用Python工具来分析和操作程序的输出。
然而，还有更强大的方法可以将解释语言(如Python)与编译语言(如C或C++)组合在一起使用。
一种是扩展Python，通过编译成共享库的C或C++模块在这些类型上提供新类型和新功能，
另一种是将Python解释器嵌入到C或C++程序中。两种方法都需要下列条件:
- Python解释器的工作版本
- Python头文件Python.h的可用性
- Python运行时库libpython
三个组件所使用的Python版本必须相同。

FindPythonLibs.cmake 模块将查找Python头文件和库的标准位置。示例如下：
```
find_package(PythonInterp REQUIRED)
find_package(PythonLibs ${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR} EXACT REQUIRED)

...

target_include_directories(hello-embedded-python
    PRIVATE
    ${PYTHON_INCLUDE_DIRS}
    )

target_link_libraries(hello-embedded-python
    PRIVATE
    ${PYTHON_LIBRARIES}
    )
```
使用 EXACT 关键字，限制CMake检测特定的版本，在本例中是匹配的相应Python版本的包括文件和库。
我们可以使用 `PYTHON_VERSION_STRING` 变量，进行更接近的匹配:
```
find_package(PythonInterp REQUIRED)
find_package(PythonLibs ${PYTHON_VERSION_STRING} EXACT REQUIRED)
```

当Python不在标准安装目录中，我们如何确定Python头文件和库的位置是正确的？
对于Python解释器，可以通过CLI的 `-D` 选项传递 `PYTHON_LIBRARY` 和 `PYTHON_INCLUDE_DIR` 选项
来强制CMake查找特定的目录。这些选项指定了以下内容:
- `PYTHON_LIBRARY`：指向Python库的路径
- `PYTHON_INCLUDE_DIR`：Python.h所在的路径

CMake 3.12版本中增加了新的Python检测模块，旨在解决这个棘手的问题。
我们 CMakeLists.txt 的检测部分也将简化为:
```
find_package(Python COMPONENTS Interpreter Development REQUIRED)
```
