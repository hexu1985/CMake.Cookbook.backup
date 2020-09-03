### 1.10 使用控制流

CMake还提供了创建循环的语言工具： foreach endforeach 和 while-endwhile 。
两者都可以与 break 结合使用，以便尽早从循环中跳出。

CMake中，列表是用分号分隔的字符串组。列表可以由 list 或 set 命令创建。
例如， `set(VAR a b c d e)` 和 `list(APPEND VAR a b c d e)` 都创建了列表 a;b;c;d;e 。

`foreach()` 的几种使用方式:
- `foreach(loop_var arg1 arg2 ...)` : 其中提供循环变量和显式项列表。例如：
    ```
    list(
        APPEND sources_with_lower_optimization
        geometry_circle.cpp
        geometry_rhombus.cpp
        )

    message(STATUS "Querying sources properties using plain syntax:")
    foreach(_source ${sources_with_lower_optimization})
        get_source_file_property(_flags ${_source} COMPILE_FLAGS)
        message(STATUS "Source ${_source} has the following extra COMPILE_FLAGS: ${_flags}")
    endforeach()
    ```
    注意，如果项目列表位于变量中，则必须显式展开它；也就是说， ${sources_with_lower_optimization} 必须作为参数传递。

- `foreach(loop_var range ...)`：通过指定一个范围，可以对整数进行循环，例如： 
    ```
    foreach(loop_var range stop) 
    ```
    或 
    ```
    foreach(loop_var range start stop [step]) 。
    ```

- `foreach(loop_var IN LISTS [list1[...]])`： 对列表值变量的循环，例如： 
    ```
    list(
        APPEND sources_with_lower_optimization
        geometry_circle.cpp
        geometry_rhombus.cpp
        )

    message(STATUS "Setting source properties using IN LISTS syntax:")
    foreach(_source IN LISTS sources_with_lower_optimization)
        set_source_files_properties(${_source} PROPERTIES COMPILE_FLAGS -O2)
        message(STATUS "Appending -O2 flag for ${_source}")
    endforeach()
    ```
    参数解释为列表，其内容就会自动展开。

