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
  AR ?= ar
  GCC ?= gcc
else
  AR ?= $(TRIPLET)-ar
  GCC ?= $(TRIPLET)-gcc
endif

# We follow the directory layout used by Fedora which appears to be
# followed by Debian as well.
LIBDIR ?= $(PREFIX)/$(TRIPLET)/sys-root/mingw/lib

version = 0.2.0

.PHONY: all
all: VBA/Interaction.o
	"$(AR)" rcs libbsa.a VBA/Interaction.o

%.S : %.ll
	"$(LLC)" -mtriple="$(TRIPLET)" -relocation-model=static $< -o "$@"

%.o : %.S
	"$(GCC)" -c $< -o "$@"

.PHONY: install
install:
	mkdir -p "$(LIBDIR)"
	cp libbsa.a "$(LIBDIR)"

.PHONY: clean
clean:
	rm -f libbsa.a
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
