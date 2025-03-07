# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	bash-4.2-execute-job-control.patch #383237
	bash-4.2-parallel-build.patch
	bash-4.2-no-readline.patch
	bash-4.2-read-retry.patch #447810
	bash-4.2-speed-up-read-N.patch
)
_BASH_BUILD_REQUIRE_BISON=true # bash42-005, bash42-012, bash42-016, bash42-034, bash42-042, bash42-049, bash42-051, bash42-053
_BASH_BUILD_USE_ARCHIVED_PATCHES=true
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
