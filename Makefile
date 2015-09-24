# Program COnfig
# DIR CONFIGURATION
dir = life
objdir = obj
bindir = bin
srcdir = src
VPATH = $(srcdir)

# DOSBOX CONFIGURATION
dosbox = "C:\dev\assembly\tools\DOSBox-0.74\dosbox.exe"
dosboxoptions = -noconsole
dosboxmountcommands = -c "mount C: \"C:\dev\assembly\workspace\\""
dosboxsetupcommands = -c "set PATH=Z:\;C:\Tasm\;"
dosboxinitcommands = -c "C:" -c \"cd C:\$$(dir)\"
dosboxcommands = $(dosboxmountcommands) $(dosboxsetupcommands) $(dosboxinitcommands)

# COMMANDS
TASM = $(dosbox) $(dosboxoptions) $(dosboxcommands) -c "tasm
TLINK = $(dosbox) $(dosboxoptions) $(dosboxcommands) -c "tlink
TRUN = $(dosbox) $(dosboxoptions) $(dosboxcommands) -c
OBJS = obj\life.obj obj\framer.obj obj\utils.obj

# Targets
bin\life.exe: $(OBJS) | bin
	$(TLINK) ${objdir}\life.obj+${objdir}\framer.obj+${objdir}\utils.obj, $@"
	$(TRUN) \"${bindir}\life.exe\"

obj\life.obj: life.asm | obj
	$(TASM) $(srcdir)\life.asm, $(objdir)" #-c exit
	
obj\framer.obj: framer.asm | obj
	$(TASM) $(srcdir)\framer.asm, $(objdir)" #-c exit

obj\utils.obj: utils.asm | obj
	$(TASM) $(srcdir)\utils.asm, $(objdir)" #-c exit

obj:
	mkdir $@
	
bin:
	mkdir $@