### 2.3 处理与编译器相关的源代码

通过定义以下目标编译定义(`CMAKE_CXX_COMPILER_ID`)，让预处理器了解编译器的名称和供应商:
```
target_compile_definitions(hello-world PUBLIC "COMPILER_NAME=\"${CMAKE_CXX_COMPILER_ID}\"")
if(CMAKE_CXX_COMPILER_ID MATCHES Intel)
    target_compile_definitions(hello-world PUBLIC "IS_INTEL_CXX_COMPILER")
endif()
if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
    target_compile_definitions(hello-world PUBLIC "IS_GNU_CXX_COMPILER")
endif()
if(CMAKE_CXX_COMPILER_ID MATCHES PGI)
    target_compile_definitions(hello-world PUBLIC "IS_PGI_CXX_COMPILER")
endif()
if(CMAKE_CXX_COMPILER_ID MATCHES XL)
    target_compile_definitions(hello-world PUBLIC "IS_XL_CXX_COMPILER")
endif()
```
