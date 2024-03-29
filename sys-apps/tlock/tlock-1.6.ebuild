# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Terminal lock"
HOMEPAGE="http://pjp.dgplug.org/tools/"
SRC_URI="http://pjp.dgplug.org/tools/${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
BDEPEND="sys-libs/ncurses"
RDEPEND=${BDEPEND}
PATCHES=("${FILESDIR}/${P}-include-crypt-h.patch")

pkg_setup() {
	local args=$(pkg-config --libs ncurses)
	export LDFLAGS="${args} ${LDFLAGS-}" LIBS="${args} ${LIBS-}"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
