# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24 ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_DOC=rdoc
RUBY_FAKEGEM_DOC_SOURCES="ext/digest/xxhash/ext.c lib/digest/xxhash/version.rb"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST=rake
RUBY_FAKEGEM_TASK_TEST=test
RUBY_FAKEGEM_EXTENSIONS=("ext/digest/xxhash/extconf.rb")

inherit ruby-fakegem

DESCRIPTION="An XXHash library that complies with Digest::Instance's functional design"

HOMEPAGE='https://github.com/konsolebox/digest-xxhash-ruby'
LICENSE=MIT

SLOT=0
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

ruby_add_bdepend ">=dev-ruby/rake-compiler-1.0 || ( <dev-ruby/rake-compiler-1.1.3 >dev-ruby/rake-compiler-1.1.5 )"
ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.8 <dev-ruby/minitest-6 )"

each_ruby_compile() {
	${RUBY} -S rake compile || die 'Failed to compile extension.'
	use doc && rdoc --quiet --ri --output=ri ${RUBY_FAKEGEM_DOC_SOURCES}
}

each_ruby_install() {
	each_fakegem_install

	if use doc; then
		insinto "$(ruby_fakegem_gemsdir)/doc/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}"
		doins -r ri
	fi
}
