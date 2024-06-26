# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..12} )
inherit desktop python-r1 xdg

DESCRIPTION="GTK image viewer for comic book archives"
HOMEPAGE="https://sourceforge.net/projects/mcomix/"
SRC_URI="https://downloads.sourceforge.net/project/mcomix/MComix-${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="comicthumb thumbnailer"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	media-libs/libjpeg-turbo
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	!media-gfx/comix"
BDEPEND="sys-devel/gettext
	app-arch/gzip"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	thumbnailer? ( comicthumb )"

PATCHES=("${FILESDIR}/${PN}-2.1.0-repeated-format-fix.patch")

S=${WORKDIR}/${P}

src_prepare() {
	default
	use comicthumb && eapply "${FILESDIR}/${PN}-2.1.0-comicthumb-f8679cf.patch"
	gunzip mcomix.1.gz || die
}

src_install() {
	python_foreach_impl python_domodule mcomix
	python_foreach_impl python_newscript mcomixstarter.py mcomix

	if use comicthumb; then
		python_foreach_impl python_newscript mime/comicthumb comicthumb
	fi

	for size in 16 22 24 32 48; do
		doicon -s "${size}" "mime/icons/${size}x${size}/"*.png \
				"mcomix/images/${size}x${size}/mcomix.png"
	done

	doicon mcomix/images/mcomix.png
	domenu mime/mcomix.desktop
	doman mcomix.1

	insinto /usr/share/metainfo
	doins mime/mcomix.appdata.xml

	if use thumbnailer; then
		insinto /usr/share/thumbnailers
		doins mime/comicthumb.thumbnailer
	fi

	dodoc README ChangeLog
}

pkg_postinst() {
	xdg_pkg_postinst
	echo
	elog "Additional packages are required to open the most common comic archives:"
	elog
	elog "    cbr: app-arch/unrar"
	elog "    cbz: app-arch/unzip"
	elog
	elog "You can also add support for 7z or LHA archives by installing"
	elog "app-arch/p7zip or app-arch/lha. Install app-text/mupdf for"
	elog "pdf support."
	echo
}
