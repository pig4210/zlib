# 这个 Makefile 用于使用 GNU make 在 Windows 编译 zlib 静态库
# http://www.zlib.net/

ifeq "$(filter x64 x86,$(Platform))" ""
$(error Need VS Environment)
endif

ifeq "$(VPATH)" ""
$(error Need VPATH)
endif

CC 			:= cl.exe
AR			:= lib.exe

GPATH		:= $(Platform)

######## CFLAGS
CFLAGS		:= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /D WIN32 /D NDEBUG /D _UNICODE /D UNICODE /fp:except- /errorReport:none /GF /WX /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo
CFLAGS		:= $(CFLAGS) /D _LIB /D ZLIB_WINAPI
CFLAGS		:= $(CFLAGS) /I"$(VPATH)"
CFLAGS		:= $(CFLAGS) /Fd"$(GPATH)/zlib.pdb"
CFLAGS		:= $(CFLAGS) /wd4131 /wd4244 /wd4996 /wd4245 /wd4127 /wd4267 

ifeq "$(Platform)" "x86"
CFLAGS		:= $(CFLAGS) /D _USING_V110_SDK71_
endif

######## ARFLAGS
ARFLAGS		:= /LTCG /ERRORREPORT:NONE /NOLOGO /MACHINE:$(Platform) /LIBPATH:"$(GPATH)"

.PHONY : all
all : ./include/zlib.h ./include/zconf.h $(GPATH) zlib.lib
	@echo make done.

./include/%.h : $(VPATH)\\%.h
	@for %%F in ("$@") do @if not exist "%%~dpF" @mkdir "%%~dpF"
	copy "$?" "$@"

$(GPATH) :
	@if not exist "$@" @mkdir "$@"

TOP			:= $(VPATH)

vpath %.obj $(GPATH)
vpath %.lib $(GPATH)

######## 以下参考 win32/Makefile.msc ########

OBJS = adler32.obj compress.obj crc32.obj deflate.obj gzclose.obj gzlib.obj gzread.obj \
       gzwrite.obj infback.obj inflate.obj inftrees.obj inffast.obj trees.obj uncompr.obj zutil.obj

adler32.obj: $(TOP)/adler32.c $(TOP)/zlib.h $(TOP)/zconf.h

compress.obj: $(TOP)/compress.c $(TOP)/zlib.h $(TOP)/zconf.h

crc32.obj: $(TOP)/crc32.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/crc32.h

deflate.obj: $(TOP)/deflate.c $(TOP)/deflate.h $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h

gzclose.obj: $(TOP)/gzclose.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/gzguts.h

gzlib.obj: $(TOP)/gzlib.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/gzguts.h

gzread.obj: $(TOP)/gzread.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/gzguts.h

gzwrite.obj: $(TOP)/gzwrite.c $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/gzguts.h

infback.obj: $(TOP)/infback.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/inftrees.h $(TOP)/inflate.h \
             $(TOP)/inffast.h $(TOP)/inffixed.h

inffast.obj: $(TOP)/inffast.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/inftrees.h $(TOP)/inflate.h \
             $(TOP)/inffast.h

inflate.obj: $(TOP)/inflate.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/inftrees.h $(TOP)/inflate.h \
             $(TOP)/inffast.h $(TOP)/inffixed.h

inftrees.obj: $(TOP)/inftrees.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/inftrees.h

trees.obj: $(TOP)/trees.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h $(TOP)/deflate.h $(TOP)/trees.h

uncompr.obj: $(TOP)/uncompr.c $(TOP)/zlib.h $(TOP)/zconf.h

zutil.obj: $(TOP)/zutil.c $(TOP)/zutil.h $(TOP)/zlib.h $(TOP)/zconf.h

################################################

%.obj : $(VPATH)/%.c
	$(CC) $(CFLAGS) "$<" -Fo"$(GPATH)/$@"

zlib.lib : $(OBJS)
	$(AR) $(ARFLAGS) /OUT:"$(GPATH)/$@" $(OBJS)
