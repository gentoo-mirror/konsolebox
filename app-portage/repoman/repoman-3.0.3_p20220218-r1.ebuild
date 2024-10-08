# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..12} )
PYTHON_REQ_USE='bzip2(+)'

inherit distutils-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gentoo/portage.git"
	S=${WORKDIR}/${P}/repoman
else
	COMMIT=b88611567dc9345e6e09de32dc4bafe69719bc9c
	SRC_URI="https://github.com/gentoo/portage/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
	S=${WORKDIR}/portage-${COMMIT}/repoman
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

DESCRIPTION="Repoman is a Quality Assurance tool for Gentoo ebuilds"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
RESTRICT="mirror"

RDEPEND="
	>=sys-apps/portage-3.0.18[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.6.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	eapply -p2 "${FILESDIR}/${P}-shlex-split.patch"
	distutils-r1_python_prepare_all
}

python_test() {
	unset REPOMAN_DEFAULT_OPTS
	esetup.py test
}

python_install() {
	# Install sbin scripts to bindir for python-exec linking
	# they will be relocated in pkg_preinst()
	distutils-r1_python_install \
		--system-prefix="${EPREFIX}/usr" \
		--bindir="$(python_get_scriptdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--sbindir="$(python_get_scriptdir)" \
		--sysconfdir="${EPREFIX}/etc" \
		"${@}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog ""
		elog "This release of repoman is from the new portage/repoman split"
		elog "release code base."
		elog "This new repoman code base is still being developed.  So its API's"
		elog "are not to be considered stable and are subject to change."
		elog "The code released has been tested and considered ready for use."
		elog "This however does not guarantee it to be completely bug free."
		elog "Please report any bugs you may encounter."
		elog ""
	fi
}
