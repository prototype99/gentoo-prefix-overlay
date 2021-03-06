# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

# ebuild generated by hackport 0.2.18

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="JavaScript analysis tools"
HOMEPAGE="http://github.com/jswebtools/language-ecmascript"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=dev-haskell/data-default-0.4*[profile?]
		>=dev-haskell/mtl-1.1.0.1[profile?]
		<dev-haskell/parsec-3.2.0[profile?]
		>=dev-haskell/syb-0.1[profile?]
		=dev-haskell/uniplate-1.6*[profile?]
		>=dev-lang/ghc-6.10.1"
DEPEND="${RDEPEND}
		test? ( dev-haskell/hunit
		)
		>=dev-haskell/cabal-1.10"
