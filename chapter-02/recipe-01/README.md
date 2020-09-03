### 2.1 检测操作系统

CMake为目标操作系统定义了 `CMAKE_SYSTEM_NAME` ，因此不需要使用定制命令、工具或脚本来查询此信息。
然后，可以使用此变量的值实现特定于操作系统的条件和解决方案。
在具有 uname 命令的系统上，将此变量设置为 uname -s 的输出。
该变量在macOS上设置为“Darwin”。在Linux和Windows上，它分别计算为“Linux”和“Windows”。

根据检测到的操作系统信息打印消息，示例如下：
```
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    message(STATUS "Configuring on/for Linux")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    message(STATUS "Configuring on/for macOS")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    message(STATUS "Configuring on/for Windows")
elseif(CMAKE_SYSTEM_NAME STREQUAL "AIX")
    message(STATUS "Configuring on/for IBM AIX")
else()
    message(STATUS "Configuring on/for ${CMAKE_SYSTEM_NAME}")
endif()
```
