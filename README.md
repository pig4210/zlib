# zlib

这里提供的[Makefile.bat](./Makefile.bat)，使用VS2017命令行编译项目

如需要使用其它VS编译其它版本，请修改如下配置：

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\xxx-x.x.x

由于各方面考虑，不采用官方提供的方法编译

---- ---- ---- ----

## 官方使用VS编译zlib的方法

- 官方使用VS命令行编译zlib

  1. 打开VC命令行(x64/x86)
  2. 进入win32目录。`cd zlib-x.x.x\win32`
  3. 编译zlib。`nmake /f Makefile.msc`
  4. 生成的文件处于`zlib-x.x.x\win32\`

- 官方使用VS编译zlib

  VS工程目录`zlib-x.x.x\contrib\vstudio`，其下有不同版本的VS工程
