PKGNAME  = dfa
PKGVERN  = v2017.9

# Final Releae direcotry
MAIN_INC = ../../include
MAIN_LIB = ../../lib
MAIN_BIN = ../../bin

# Local Compile directory
SRC_DIR   = src
OBJ_DIR   = obj
LIB_DIR   = lib
BIN_DIR   = bin

#
#
#
MKDIR   = mkdir -p
CP	= cp -fr
CAT	= cat

#
# for cc
#
CC      = gcc -g -fPIC 
#-D_LARGEFILE64_SOURCE
CFLAGS	=   \
                -DPKGNAME=\"$(PKGNAME)\" \
                -DPKGVERN=\"$(PKGVERN)\" \
		-I $(MAIN_INC) \
		-L $(MAIN_LIB)
EXTFLAGS= 
LEX     = flex -l
LFLAGS  =
YACC    = bison -y
YFLAGS  = -d 
AR      = ar -cr
RANLIB	= ranlib

####
