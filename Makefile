# Program COnfig
# DIR CONFIGURATION
dir = life
objdir = obj
bindir = bin
srcdir = src
VPATH = $(srcdir)

# DOSBOX CONFIGURATION
dosbox = "C:\dev\assembly\tools\DOSBox-0.74\dosbox.exe"
dosboxoptions = -exit -noconsole -noautoexec
dosboxmountcommands = -c "mount C: \"C:\dev\assembly\workspace\\""
dosboxsetupcommands = -c "set PATH=Z:\;C:\Tasm\;"
dosboxinitcommands  = -c "C:" -c "cd C:\life"
dosboxcommands = $(dosboxmountcommands) $(dosboxsetupcommands) $(dosboxinitcommands)
dosboxconf = "C:\dev\assembly\tools\DOSBox-0.74\MyConf\tasmmounted.conf"

# COMMANDS
TASM = $(dosbox) $(dosboxoptions) -conf $(dosboxconf) $(dosboxcommands) -c "tasm
TLINK = $(dosbox) $(dosboxoptions) -conf $(dosboxconf) $(dosboxcommands) -c "tlink
TRUN = $(dosbox) $(dosboxoptions) -conf $(dosboxconf) $(dosboxcommands) -c
OBJS = obj\life.obj obj\framer.obj obj\utils.obj

# Targets
bin\life.exe: $(OBJS) | bin
	$(TLINK) ${objdir}\life.obj+${objdir}\framer.obj+${objdir}\utils.obj, $@"
	$(TRUN) "bin\life.exe"

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