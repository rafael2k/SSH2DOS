#
# OpenWatcom makefile for SSH2DOS (real mode - large)
#

# Debug
#DEBUG=-d2

# uncomment this for B&W mode
COLOR = -DCOLOR

#################################################################
# In normal cases, no other settings should be changed below!!! #
#################################################################

WATCOM=/usr/bin/watcom
ELKS_TOPDIR=/home/rafael2k/programs/devel/elks

CC = ewcc
LINKER = wlink LibPath lib;$(%WATT_ROOT)/lib


CFLAGS= -I$(ELKS_TOPDIR)/libc/include -I$(ELKS_TOPDIR)/include -I$(ELKS_TOPDIR)/elks/include -I$(WATCOM)/h -I./include

# to use with owcc:
#CFLAGS = -bnone -mcmodel=l -march=i86 -Os -std=c99 -Wc,-fpi87 -Wc,-zev -Wc,-x -fno-stack-check -fnostdlib -Wall -Wextra -Wc,-wcd=303 -I./include/ -I/home/rafael2k/programs/devel/elks/libc/include -I/home/rafael2k/programs/devel/elks/include -I/home/rafael2k/programs/devel/elks/elks/include -I/usr/bin/watcom/h

.c.obj:
        $(CC) $(CFLAGS) $[@

LIBS = lib\misc.lib lib\crypto.lib lib\ssh.lib lib\vt100.lib $(%WATT_ROOT)\lib\wattcpwl.lib lib\zlib_l.lib

all:    ssh2dos.os2 sftpdos.os2 scp2dos.os2 telnet.os2

ssh2dos.os2 : ssh2dos.obj $(LIBS)
	$(LINKER) @ssh2dos.lnk

sftpdos.os2 : sftpdos.obj sftp.obj $(LIBS)
	$(LINKER) @sftpdos.lnk

scp2dos.os2 : scpdos.obj $(LIBS)
	$(LINKER) @scp2dos.lnk

telnet.os2  : telnet.obj lib\misc.lib lib\vt100.lib $(%WATT_ROOT)\lib\wattcpwl.lib
	$(LINKER) @telnet.lnk

ttytest.os2 : ttytest.obj $(LIBS)
	$(LINKER) @ttytest.lnk

lib\crypto.lib: sshrsa.obj sshdes.obj sshmd5.obj sshbn.obj sshpubk.obj int64.obj sshaes.obj  sshsha.obj sshsh512.obj sshdss.obj sshsh256.obj 
	wlib -b -c lib\crypto.lib -+sshrsa.obj -+sshdes.obj -+sshmd5.obj -+sshbn.obj -+sshpubk.obj
	wlib -b -c lib\crypto.lib -+int64.obj -+sshaes.obj -+sshsha.obj -+sshsh512.obj -+sshdss.obj -+sshsh256.obj

lib\ssh.lib: negotiat.obj transprt.obj auth.obj channel.obj
	wlib -b -c lib\ssh.lib -+negotiat.obj -+transprt.obj -+auth.obj -+channel.obj

lib\vt100.lib: vttio.obj vidio.obj keyio.obj keymap.obj
	wlib -b -c lib\vt100.lib -+vttio.obj -+vidio.obj -+keyio.obj -+keymap.obj

lib\misc.lib: common.obj shell.obj proxy.obj
	wlib -b -c lib\misc.lib -+common.obj -+shell.obj -+proxy.obj

clean: .SYMBOLIC
	del *.obj
	del *.map
	del lib\vt100.lib
	del lib\crypto.lib
	del lib\misc.lib
	del lib\ssh.lib
	del ssh2dos.os2
	del scp2dos.os2
	del sftpdos.os2
	del telnet.os2
	del ttytest.os2
