### 3.4 检测BLAS和LAPACK数学库

许多数据算法严重依赖于矩阵和向量运算，因为操作的数据量比较大，因此高效的实现有绝对的必要。幸运的是，有专家库可用：基本线性代数子程序(BLAS)和线性代数包(LAPACK)，为许多线性代数操作提供了标准API。

我们通过CMake脚本链接到这些库，并展示如何用不同语言编写的库。

1. 我们验证Fortran和C/C++编译器是否能协同工作，并生成头文件，这个文件可以处理名称混乱。两个功能都由 FortranCInterface 模块提供:
```
include(FortranCInterface)
FortranCInterface_VERIFY(CXX)
FortranCInterface_HEADER(fc_mangle.h
    MACRO_NAMESPACE "FC_"
    SYMBOLS DSCAL DGESV
    )
```

2. 找到BLAS和LAPACK:
```
find_package(BLAS REQUIRED)
find_package(LAPACK REQUIRED)
```
FindBLAS.cmake 和 FindLAPACK.cmake 将在标准位置查找BLAS和LAPACK库。

3. 添加一个库，其中包含BLAS和LAPACK包装器的源代码，并链接到 LAPACK_LIBRARIES，其中也包含 BLAS_LIBRARIES:
```
add_library(math "")
target_sources(math
    PRIVATE
    CxxBLAS.cpp
    CxxLAPACK.cpp
    )

target_include_directories(math
    PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    )

target_link_libraries(math
    PUBLIC
    ${LAPACK_LIBRARIES}
    )
```
目标的包含目录和链接库声明为 PUBLIC，因此任何依赖于数学库的附加目标也将在其包含目录中。

4. 我们添加一个可执行目标并链接 math ：
```
add_executable(linear-algebra "")
target_sources(linear-algebra
    PRIVATE
    linear-algebra.cpp
    )

target_link_libraries(linear-algebra
    PRIVATE
    math
    )
```

