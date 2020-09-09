### 2.5 检测处理器指令集

`cmake_host_system_information`指令 ，它查询运行CMake的主机系统的系统信息。

`configure_file` 命令的作用是让普通文件也能使用CMake中的变量。

例如：
config.h.in 如下:
```
#pragma once

#define NUMBER_OF_LOGICAL_CORES @_NUMBER_OF_LOGICAL_CORES@
#define NUMBER_OF_PHYSICAL_CORES @_NUMBER_OF_PHYSICAL_CORES@
#define TOTAL_VIRTUAL_MEMORY @_TOTAL_VIRTUAL_MEMORY@
#define AVAILABLE_VIRTUAL_MEMORY @_AVAILABLE_VIRTUAL_MEMORY@
#define TOTAL_PHYSICAL_MEMORY @_TOTAL_PHYSICAL_MEMORY@
#define AVAILABLE_PHYSICAL_MEMORY @_AVAILABLE_PHYSICAL_MEMORY@
#define IS_64BIT @_IS_64BIT@
#define HAS_FPU @_HAS_FPU@
#define HAS_MMX @_HAS_MMX@
#define HAS_MMX_PLUS @_HAS_MMX_PLUS@
#define HAS_SSE @_HAS_SSE@
#define HAS_SSE2 @_HAS_SSE2@
#define HAS_SSE_FP @_HAS_SSE_FP@
#define HAS_SSE_MMX @_HAS_SSE_MMX@
#define HAS_AMD_3DNOW @_HAS_AMD_3DNOW@
#define HAS_AMD_3DNOW_PLUS @_HAS_AMD_3DNOW_PLUS@
#define HAS_IA64 @_HAS_IA64@
#define OS_NAME "@_OS_NAME@"
#define OS_RELEASE "@_OS_RELEASE@"
#define OS_VERSION "@_OS_VERSION@"
#define OS_PLATFORM "@_OS_PLATFORM@"
```

查询主机系统的信息，获取一些关键字，并通过config.h.in生成config.h:
```
foreach(key IN ITEMS
        NUMBER_OF_LOGICAL_CORES
        NUMBER_OF_PHYSICAL_CORES
        TOTAL_VIRTUAL_MEMORY
        AVAILABLE_VIRTUAL_MEMORY
        TOTAL_PHYSICAL_MEMORY
        AVAILABLE_PHYSICAL_MEMORY
        IS_64BIT
        HAS_FPU
        HAS_MMX
        HAS_MMX_PLUS
        HAS_SSE
        HAS_SSE2
        HAS_SSE_FP
        HAS_SSE_MMX
        HAS_AMD_3DNOW
        HAS_AMD_3DNOW_PLUS
        HAS_IA64
        OS_NAME
        OS_RELEASE
        OS_VERSION
        OS_PLATFORM
    )
    cmake_host_system_information(RESULT _${key} QUERY ${key}) 
endforeach()

configure_file(config.h.in config.h @ONLY)
```
