### 2.6 为Eigen库使能向量化

由于线性代数运算可以从Eigen库中获得很好的加速，所以在使用Eigen库时，就要考虑向量化。
我们所要做的就是，指示编译器为我们检查处理器，并为当前体系结构生成本机指令。

不同的编译器供应商会使用不同的标志来实现这一点：
GNU编译器使用 `-march=native` 标志来实现这一点，而Intel编译器使用 `-xHost` 标志。
使用 CheckCXXCompilerFlag.cmake 模块提供的 `check_cxx_compiler_flag` 函数
进行编译器标志的检查:
```
check_cxx_compiler_flag("-march=native" _march_native_works)
```
这个函数接受两个参数:
- 第一个是要检查的编译器标志。
- 第二个是用来存储检查结果(true或false)的变量。如果检查为真，我们将工作标志添加到 `_CXX_FLAGS` 变量中，该变量将用于为可执行目标设置编译器标志。

例如：
```
include(CheckCXXCompilerFlag)
check_cxx_compiler_flag("-march=native" _march_native_works)
check_cxx_compiler_flag("-xHost" _xhost_works)

set(_CXX_FLAGS)
if(_march_native_works)
    message(STATUS "Using processor's vector instructions (-march=native compiler flag set)")
    set(_CXX_FLAGS "-march=native")
elseif(_xhost_works)
    message(STATUS "Using processor's vector instructions (-xHost compiler flag set)")
    set(_CXX_FLAGS "-xHost")
else()
    message(STATUS "No suitable compiler flag found for vectorization")
endif()

...

add_executable(linear-algebra linear-algebra.cpp)
target_compile_options(linear-algebra PRIVATE ${_CXX_FLAGS})
```
