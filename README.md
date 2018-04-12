# zlib

这里提供的[Makefile.bat](./Makefile.bat)，使用VS2017命令行编译项目

如需使用其它VS，请修改如下配置：

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build

源代码目录自动定位，如需指定其它源代码目录，请修改如下代码的VPATH：

    for /d %%P in ("%MyPath%\\%ProjectName%*") do set VPATH=%%~fP

由于各方面考虑，不采用官方提供的方法编译

在已有VC命令行环境下运行脚本，只编译当前平台相符的库，并且输出编译信息

无VC命令行环境时，脚本静默编译x64 & x86

---- ---- ---- ----

## 官方使用VS编译zlib的方法

- 官方使用VS命令行编译zlib

  1. 打开VC命令行(x64/x86)
  2. 进入win32目录。`cd zlib-x.x.x\win32`
  3. 编译zlib。`nmake /f Makefile.msc`
  4. 生成的文件处于`zlib-x.x.x\win32\`

- 官方使用VS编译zlib

  VS工程目录`zlib-x.x.x\contrib\vstudio`，其下有不同版本的VS工程
