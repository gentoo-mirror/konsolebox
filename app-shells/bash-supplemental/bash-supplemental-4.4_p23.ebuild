# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	bash-4.4-jobs_overflow.patch #644720
	bash-4.4-set-SHOBJ_STATUS.patch #644720
)
_BASH_BUILD_USE_ARCHIVED_PATCHES=true
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
