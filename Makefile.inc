# 这个 Makefile 用于使用 GNU make 在 Windows 编译 zlib 静态库
# http://www.zlib.net/

TOP         := $(SRCPATH)

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
CFLAGS      += /D_LIB /DZLIB_WINAPI /wd4131 /wd4244 /wd4996 /wd4245 /wd4127 /wd4267

vpath %.c   $(SRCPATH)
vpath %.obj $(DSTPATH)

######## INC
INCPATH     := ./include

.PHONY : inc
inc : $(INCPATH)/zlib.h $(INCPATH)/zconf.h

$(INCPATH) :
	@mkdir "$@"

$(INCPATH)/% : % | $(INCPATH)
	copy /y "$(?D)\\$(?F)" "$(@D)\\$(@F)"

######## LIB
%.obj : %.c | $(DSTPATH)
	$(CC) $(CFLAGS) /Fo"$(DSTPATH)/$(@F)" "$<"

.PHONY : lib
lib : zlib.lib

zlib.lib : $(OBJS)
	$(AR) $(ARFLAGS) /OUT:"$(DSTPATH)/$(@F)" $^

######## ALL
all :   lib   inc
	@echo make done.