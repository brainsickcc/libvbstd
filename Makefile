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

PREFIX ?= /usr/local

# We use MinGW-w64's 32-bit--targetting toolchain.
TRIPLET = i686-w64-mingw32
# We follow the directory layout used by Fedora which appears to be
# followed by Debian as well.
LIBDIR ?= $(PREFIX)/$(TRIPLET)/sys-root/mingw/lib

RUST_VERSION = 1.15.1

.PHONY: all
all:
	rustup run "$(RUST_VERSION)" cargo build --target=i686-pc-windows-gnu \
	                                         --release

.PHONY: install
install:
	mkdir -p "$(LIBDIR)"
	cp target/i686-pc-windows-gnu/release/vbstd.lib "$(LIBDIR)/libvbstd.a"

.PHONY: clean
clean:
	rm -Rf target/
