# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	bash-4.0-configure.patch #304901
	bash-4.x-deferred-heredocs.patch
	bash-2.05b-parallel-build.patch #41002
	bash-4.0-ldflags-for-build.patch #211947
	bash-4.0-negative-return.patch
	bash-4.0-parallel-build.patch #267613
	bash-4.2-dev-fd-buffer-overflow.patch #431850
)
_BASH_BUILD_REQUIRE_BISON=true # bash40-001, bash40-003, bash40-006, bash40-007, bash40-008, bash40-010, bash40-011, bash40-017, bash40-022, bash40-040, bash40-042, bash40-044
_BASH_BUILD_USE_ARCHIVED_PATCHES=true
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

src_prepare() {
	bash-build_src_prepare
	sed -i '1i#define NEED_FPURGE_DECL' execute_cmd.c || die # needs fpurge() decl
	sed -i '/\.o: .*shell\.h/s:$: pathnames.h:' Makefile.in || die #267613
}
