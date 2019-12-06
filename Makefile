# --------------------------------------------------------------------
# Set variables for file names, such as name of program, Edit these,
# not the code further down the file.
# --------------------------------------------------------------------
progname 	= a.out

# --------------------------------------------------------------------
# compiler/assembler options ....;
# --------------------------------------------------------------------

# C programming
SHELL 		= /bin/bash
CC 		= avr-gcc
defs		=
include_dirs	= -I./include -I../include
CFLAGS		= -Wall -Wextra -mmcu=atmega328p -mrelax -O2 -flto -ffreestanding
CPPFLAGS	= -Wp,-Wall,-Wextra $(defs) $(include_dirs)
LDFLAGS		= -Wl,-Map=$@.map -nostdlib -nostartfiles
LDLIBS		=

# bison/flex options
YACC		= bison
YFLAGS		= -d
LEX		= flex
LFLAGS		= --full

# The rest of this file is the programmatic part of this makefile. 
######################################################################
# Preperation for flex/bison files
ysource		= $(wildcard *.y)
lexsource	= $(wildcard *.lex)
ycsource	= $(patsubst %.y,	%.tab.c,	$(ysource))
lexcsource	= $(patsubst %.lex,	%.yy.c,		$(lexsource))

# --------------------------------------------------------------------
# source and object defitions corresponding to the built in and user
# defined implicit rules of interest to this makefile.
# (e.g. .c.o: )
# --------------------------------------------------------------------
csource 	= $(ycsource) $(lexcsource) $(wildcard *.c)
gaSsource	= $(wildcard *.S)
source		= $(gaSsource) $(csource)
# IF YOU ADD A NEW AUTOMATIC RULE FOR A SOURCE ABOVE, YOU MUST ADD A
# AN ENTRY BELOW FOR THE OBJECT FILE:
cobjects 	:= $(patsubst %.c, 	%.o, 	$(csource))
gaSobjects	:= $(patsubst %.S,	%.o,	$(gaSsource))
objects = $(gaSobjects) $(cobjects)

#
# REMEMBER TO DEFINE A NEW IMPLICIT RULE AT THE END OF THIS FILE FOR
# YOUR NEW FILENAME EXTENSION, IF IT IS NOT A BUILT IN EXPLICIT RULE
#

# --------------------------------------------------------------------
# DEFAULT RULE, THIS RULE MUST BE FIRST
# --------------------------------------------------------------------
all : $(progname)

# --------------------------------------------------------------------
# phony targets
# --------------------------------------------------------------------
.PHONY : clean flash
clean :
# Only use shell wild cards in rm operations.  Using $(objects) may
# cause project files to be deleted if there is anything wrong with
# the value of $(objects).
	rm -f $(progname) $(progname).so *.o *.d 
	find . -name '*~' -print0 | xargs -0 rm -f
	$(MAKE) -C ../libatmega328p clean

flash :
	avrdude  -pm328p -c arduino -P/dev/ttyACM0 -U flash:w:$(progname)

# --------------------------------------------------------------------
# program targets
# --------------------------------------------------------------------
include $(csource:.c=.d) $(gaSsource:.S=.d)

$(progname) : $(objects) \
../libatmega328p/libatmega328p.a
	$(CC) $(CFLAGS) $(LDFLAGS)  -o $@ $^ $(LDLIBS)

../libatmega328p/libatmega328p.a:
	$(MAKE) -C ../libatmega328p

# CUSTOM RULES CAN BE DEFINED BETWEEN HERE AND THE NEXT WARNING
# COMMENT.

# custom rules here :D

# 
# %.o : %.c is a built in implicit rule.
# %.o : %.C is a built in implicit rule.
# 
# ADD MORE IMPLICIT RULES BELOW AS NECESSARY
%.d: %.c Makefile
	@set -e; rm -f $@; \
	$(CC) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$
%.d: %.S Makefile
	@set -e; rm -f $@; \
	$(CC) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$
%.o : %.c Makefile
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
%.o : %.S Makefile
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
%.tab.c : %.y Makefile
	$(YACC) $(YFLAGS)  $<
%.yy.c : %.lex Makefile
	$(LEX) $(LFLAGS)  -o $@ $<
