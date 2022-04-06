# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KONSOLEBOX_SCRIPTS_COMMIT="ca37e4b050389f96518245176c76674665157b47"
KONSOLEBOX_SCRIPTS_EXT=bash
inherit konsolebox-scripts

DESCRIPTION="Relatively copies binaries along with their dependencies to a directory"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="public-domain"
RDEPEND=">=app-shells/bash-4.0 sys-apps/coreutils sys-libs/glibc"
