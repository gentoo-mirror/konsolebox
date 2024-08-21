# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="Seamlessly manage your app's Ruby environment"
HOMEPAGE="https://github.com/rbenv/rbenv"
LICENSE="MIT"

SLOT=0

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rbenv/rbenv.git"
	EGIT_BRANCH=master
else
	SRC_URI="https://github.com/rbenv/rbenv/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
	RESTRICT="mirror"
	S=${WORKDIR}/${P}
fi

ECONF_SOURCE=src
RDEPEND="app-shells/bash"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" -C src
}

src_install() {
	exeinto /usr/libexec/rbenv
	doexe libexec/*
	dosym ../libexec/rbenv/rbenv /usr/bin/rbenv

	set -- rbenv.d/*
	if [[ $# -gt 0 && -e $1 ]]; then
		insinto /usr/lib/rbenv/hooks
		doins -r "$@"
	fi

	newbashcomp completions/rbenv.bash rbenv
	dodoc README.md
}

pkg_postinst() {
	elog "Run 'rbenv init' and follow printed instructions to setup shell integration of rbenv for the current user."
	elog "Also read README.md or visit ${HOMEPAGE}."
}
