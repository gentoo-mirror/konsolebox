# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ruby-fakegem-compat.eclass
# @MAINTAINER:
# konsolebox <konsolebox@gmail.com>
# @AUTHOR:
# konsolebox <konsolebox@gmail.com>
# @SUPPORTED_EAPIS: 5 6 7 8
# @PROVIDES: ruby-fakegem
# @BLURB: Adds compatibility fixes for old ruby-fakegem.eclass

inherit use-ruby-mask ruby-utils-compat ruby-fakegem

# @FUNCTION: ruby_fakegem_extensions_installed
# @DESCRIPTION:
# Install the marker indicating that extensions have been
# installed. This is normally done as part of the extension
# installation, but may be useful when we handle extensions manually.
if ! declare -pf ruby_fakegem_extensions_installed &>/dev/null; then
	ruby_fakegem_extensions_installed() {
		local extensions_dir
		extensions_dir=$(${RUBY} --disable=did_you_mean -e "puts File.join('extensions', Gem::Platform.local.to_s, Gem.extension_api_version)") || die
		extensions_dir=$(ruby_fakegem_gemsdir)/${extensions_dir}/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION} || die
		mkdir -p "${ED}${extensions_dir}" || die
		touch "${ED}${extensions_dir}/gem.build_complete" || die
	}
fi
