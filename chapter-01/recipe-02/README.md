### 1.2 切换生成器

CMake针对不同平台支持本地构建工具列表。同时支持命令行工具(如Unix Makefile和Ninja)和集成开发环境(IDE)工具。
用以下命令，可在平台上找到生成器名单，以及已安装的CMake版本：

```shell
$ cmake --help
```

例如，我在windows上通过MSYS2的shell环境编译项目，默认会找Visual Studio C++编译器，如果我们想gnu make和g++去编译程序，
我们可以用如下命令生成Makefile

```shell
$ mkdir build
$ cd build
$ cmake -G 'Unix Makefiles' ..
$ cmake --build .
```
