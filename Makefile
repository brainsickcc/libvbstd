# Copyright © 2012 Iain Nicol

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# ``?='' only sets a Makefile variable if it has not been set already
# (namely, externally).
PREFIX ?= /usr/local
# We use MinGW-w64's 32-bit--targetting toolchain.
TRIPLET ?= i686-w64-mingw32
# llc is from LLVM.
LLC ?= llc

ifeq ($(TRIPLET),)
  GCC ?= gcc
  STRIP ?= strip
else
  GCC ?= $(TRIPLET)-gcc
  STRIP ?= $(TRIPLET)-strip
endif

# We follow the directory layout used by Fedora which appears to be
# followed by Debian as well.
BINDIR ?= $(PREFIX)/$(TRIPLET)/sys-root/mingw/bin
LIBDIR ?= $(PREFIX)/$(TRIPLET)/sys-root/mingw/lib

version = 0.1.0

# Note that ``@ #'' prevents comments inside the rules below from being
# printed to stdout.
.PHONY: all
all: VBA/Interaction.o
	@ # We produce a DLL, but we don't use the special-purpose tools
	@ # dlltool or dllwrap.  These are deprecated; see
	@ # <http://oldwiki.mingw.org/index.php/dllwrap> and its
	@ # outgoing links.
	@ #
	@ # -mwindows is used to set the subsystem to GUI, instead of
	@ # console.
	"$(GCC)" -shared VBA/Interaction.o -o libbsa.dll \
	         -Wl,--out-implib=libbsa.dll.a -mwindows
	"$(STRIP)" libbsa.dll

%.S : %.ll
	"$(LLC)" -mtriple="$(TRIPLET)" -relocation-model=pic $< -o "$@"

%.o : %.S
	"$(GCC)" -fPIC -mwindows -c $< -o "$@"

.PHONY: install
install:
	mkdir -p "$(BINDIR)"
	cp libbsa.dll "$(BINDIR)"
	mkdir -p "$(LIBDIR)"
	cp libbsa.dll.a "$(LIBDIR)"

.PHONY: clean
clean:
	rm -f libbsa.dll libbsa.dll.a
	rm -f VBA/Interaction.o
	rm -f VBA/Interaction.S
	rm -Rf dist-tmp/

.PHONY: dist
dist:
	rm -Rf dist-tmp/
	mkdir -p "dist-tmp/libbsa-$(version)/VBA/"
	cp AUTHORS COPYING .gitignore INSTALL Makefile NEWS README \
	   "dist-tmp/libbsa-$(version)/"
	cp VBA/Interaction.ll "dist-tmp/libbsa-$(version)/VBA/"
	tar -czf "libbsa-$(version).tar.gz" -C dist-tmp/ "libbsa-$(version)"
	rm -Rf dist-tmp/
