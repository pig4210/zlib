# 这个 Makefile 用于使用 GNU make 在 Windows 编译 zlib 静态库
# http://www.zlib.net/

# 如果只是单纯的 clean ，则无需 环境 和 路径
ifneq "$(MAKECMDGOALS)" "clean"

  # inc 的情况，无需环境
  ifeq "$(MAKECMDGOALS)" "inc"
  else ifeq "$(MAKECMDGOALS)" "clean inc"
  else ifeq "$(MAKECMDGOALS)" "inc clean"
  	$(error Are you kidding me ?!)
  else
    ifeq "$(filter x64 x86,$(Platform))" ""
      $(error Need VS Environment)
    endif
  endif

  ifeq "$(SRCPATH)" ""
    $(error Need SRCPATH)
  endif

endif


.PHONY : all
all : lib inc
	@echo make done.

	
TOP			:= $(SRCPATH)

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


DESTPATH	:= $(Platform)

CC 			:= cl.exe
AR			:= lib.exe

######## CFLAGS
CFLAGS		= /c /MP /GS- /Qpar /GL /analyze- /W4 /Gy /Zc:wchar_t /Zi /Gm- /Ox /Zc:inline /fp:precise /DWIN32 /DNDEBUG /D_UNICODE /DUNICODE /fp:except- /errorReport:none /GF /WX /Zc:forScope /GR- /Gd /Oy /Oi /MT /EHsc /nologo
CFLAGS		+= /D_LIB /DZLIB_WINAPI
CFLAGS		+= /I"$(SRCPATH)"
CFLAGS		+= /Fd"$(DESTPATH)/zlib.pdb"
CFLAGS		+= /wd4131 /wd4244 /wd4996 /wd4245 /wd4127 /wd4267 

ifeq "$(Platform)" "x86"
CFLAGS		+= /D_USING_V110_SDK71_
endif

######## ARFLAGS
ARFLAGS		= /LTCG /ERRORREPORT:NONE /NOLOGO /MACHINE:$(Platform) /LIBPATH:"$(DESTPATH)"


######## LIB
vpath %.c $(SRCPATH)
vpath %.h $(SRCPATH)

vpath %.obj $(DESTPATH)

.PHONY : lib
lib : $(DESTPATH)/zlib.lib

$(DESTPATH) :
	@mkdir "$@"

%.obj : %.c | $(DESTPATH)
	$(CC) $(CFLAGS) "$<" -Fo"$(DESTPATH)/$(@F)"

$(DESTPATH)/zlib.lib : $(OBJS)
	$(AR) $(ARFLAGS) /OUT:"$@" $^
	

######## INC
INCPATH		:= ./include

.PHONY : inc
inc : $(INCPATH)/zlib.h $(INCPATH)/zconf.h

$(INCPATH) :
	@mkdir "$@"

$(INCPATH)/%.h : $(SRCPATH)\\%.h | $(INCPATH)
	copy /y "$(?D)\\$(?F)" "$(@D)\\$(@F)"


######## CLEAN
.PHONY : clean
clean :
	@if exist x64 @rd /s /q x64
	@if exist x86 @rd /s /q x86
	@if exist include @rd /s /q include