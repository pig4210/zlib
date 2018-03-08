# zlib

这里提供的[Makefile.bat](./Makefile.bat)，用于使用VS2017命令行编译zlib

如需要使用其它VS编译其它版本，请修改如下参考：

    set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
    set VPATH=%MyPath%\\zlib-1.2.11

由于各方面考虑，不采用官方提供的方法编译zlib

---- ---- ---- ----

## 官方使用VS编译zlib的方法

## 官方使用VS命令行编译zlib

```
rem 打开VC命令行(x64/x86)
cd zlib-x.x.x\win32
nmake /f Makefile.msc
rem 生成的文件处于zlib-x.x.x\win32\
```

## 官方使用VS编译curl

VS工程目录`zlib-x.x.x\contrib\vstudio`，其下有不同版本的VS工程
