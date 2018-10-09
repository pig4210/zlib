# zlib

zlib 提供了 windows 下的编译支持，具体参考相关说明

---- ---- ---- ----

## NMake编译

zlib 支持 NMake 编译

```cmd
cd /d C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
call vcvarsall.bat amd64
cd /d ./zlib/zlib-1.2.11
nmake /f win32/Makefile.msc
```

生成结果 : `./win32/*.exe` & `./win32/*.lib`

---- ---- ---- ----

## VisualStudio编译

zlib 支持 VisualStudio 编译

目录 `./contrib/vstudio` ，其下有不同版本的 VS 工程

---- ---- ---- ----

## 特化编译

参考 zlib 提供的 windows 下的编译手段，自行实现 Makefile for zlib

`Makefile` 使用 gnu make 编译 zlib

`Makefile.bat` 检测当前环境，决定编译结果