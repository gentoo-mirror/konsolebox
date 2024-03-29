# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="A chroot with more isolation"
HOMEPAGE="https://github.com/vincentbernat/jchroot"
LICENSE="ISC"

SLOT=0
EGIT_REPO_URI="https://github.com/vincentbernat/jchroot.git"
EGIT_BRANCH=master

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README.md
	doman "${PN}.8"
	dobin "${PN}"
}
