# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 strip-linguas xdg-utils

LANGS="ar ast be bg ca cs de el en_GB es et eu fa fi fr gl he hi hu id it ja kk ko lb lt mn nl nn pl pt pt_BR ro ru sk sl sr sv tr uk vi zh_CN ZH_TW"
NOSHORTLANGS="en_GB zh_CN zh_TW"

DESCRIPTION="GTK+ based fast and lightweight IDE"
HOMEPAGE="http://www.geany.org"
LICENSE="GPL-2+ HPND"
SLOT=0
IUSE="doc konsolebox +vte"
REQUIRED_USE="konsolebox"

RDEPEND=">=dev-libs/glib-2.28:2
	>=x11-libs/gtk+-2.24:2
	vte? ( x11-libs/vte:0 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/glib-utils
	sys-devel/gettext
	sys-devel/patch
	virtual/pkgconfig"

pkg_setup() {
	strip-linguas ${LANGS}
}

src_unpack() {
	EGIT_REPO_URI="https://github.com/konsolebox/geany.git"
	EGIT_BRANCH=master
	git-r3_src_unpack
}

src_prepare() {
	default

	# Syntax highlighting for Portage
	sed -i -e 's:*.sh;:*.sh;*.ebuild;*.eclass;:' data/filetype_extensions.conf || die

	intltoolize --force --copy --automake || die "intltoolize failed"
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf --disable-dependency-tracking --docdir="${EPREFIX}/usr/share/doc/${PF}" \
			"$(use_enable vte)" "$(use_enable doc html-docs)"
}

src_install() {
	emake DESTDIR="${D}" DOCDIR="${D}/usr/share/doc/${PF}" install
	rm -f "${D}/usr/share/doc/${PF}/"{COPYING,GPL-2,ScintillaLicense.txt}
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
