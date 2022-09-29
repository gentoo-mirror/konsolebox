# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	"${FILESDIR}"/bash-4.3-mapfile-improper-array-name-validation.patch
	"${FILESDIR}"/bash-4.3-arrayfunc.patch
	"${FILESDIR}"/bash-4.3-protos.patch
	"${FILESDIR}"/bash-4.4-popd-offset-overflow.patch #600174
)

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
