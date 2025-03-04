# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

_BASH_BUILD_INSTALL_TYPE=supplemental
_BASH_BUILD_PATCHES=(
	autoconf-mktime-2.53.patch #220040
	bash-2.05b-parallel-build.patch #41002
	bash-3.1-protos.patch
	bash-3.0-read-memleak.patch
	bash-3.0-trap-fg-signals.patch
	bash-3.1-fix-dash-login-shell.patch #118257
	bash-3.1-dev-fd-test-as-user.patch #131875
	bash-3.1-dev-fd-buffer-overflow.patch #431850
)
_BASH_BUILD_REQUIRE_BISON=true # bash31-001, bash31-010, bash31-011, bash31-012, bash31-019, bash31-021, bash31-023
_BASH_BUILD_USE_ARCHIVED_PATCHES=true
_BASH_BUILD_VERIFY_SIG=true

inherit bash-build

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
