# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/clozurecl/clozurecl-1.9.ebuild,v 1.2 2013/03/14 04:09:37 grozin Exp $

EAPI=5
inherit eutils multilib

MY_PN=ccl
MY_P=${MY_PN}-${PV}

DESCRIPTION="ClozureCL is a Common Lisp implementation, derived from Digitool's MCL product"
HOMEPAGE="http://ccl.clozure.com/"
SRC_URI="x86?   ( ftp://ftp.clozure.com/pub/release/${PV}/${MY_P}-linuxx86.tar.gz )
		 amd64? ( ftp://ftp.clozure.com/pub/release/${PV}/${MY_P}-linuxx86.tar.gz )
		 x86-macos? ( ftp://ftp.clozure.com/pub/release/1.9/ccl-1.9-darwinx86.tar.gz )
		 x64-macos? ( ftp://ftp.clozure.com/pub/release/1.9/ccl-1.9-darwinx86.tar.gz )"
		 # ppc?   ( ftp://ftp.clozure.com/pub/release/${PV}/${MY_P}-linuxppc.tar.gz )
		 # ppc64? ( ftp://ftp.clozure.com/pub/release/${PV}/${MY_P}-linuxppc.tar.gz )"

LICENSE="LLGPL-2.1"
SLOT="0"
# KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 "
KEYWORDS="~amd64 ~x86 ~x86-macos ~x64-macos"
IUSE="doc"

DEPEND="!dev-lisp/openmcl"

S="${WORKDIR}"/${MY_PN}

ENVD="${T}"/50ccl

src_configure() {
	if use x86; then
		CCL_RUNTIME=lx86cl; CCL_HEADERS=x86-headers
	elif use amd64; then
		CCL_RUNTIME=lx86cl64; CCL_HEADERS=x86-headers64
	elif use x86-macos; then
		CCL_RUNTIME=dx86cl; CCL_HEADERS=darwin-x86-headers
	elif use x64-macos; then
		CCL_RUNTIME=dx86cl64; CCL_HEADERS=darwin-x86-headers64
	elif use ppc; then
		CCL_RUNTIME=ppccl; CCL_HEADERS=headers
	elif use ppc64; then
		CCL_RUNTIME=ppccl64; CCL_HEADERS=headers64
	fi
}

src_compile() {
	unset CCL_DEFAULT_DIRECTORY
	./${CCL_RUNTIME} -n -b -Q -e '(ccl:rebuild-ccl :full t)' -e '(ccl:quit)' || die "Compilation failed"

	# remove non-owner write permissions on the full-image
	chmod go-w ${CCL_RUNTIME}{,.image}

	# remove .svn directories
	find "${S}" -type d -name .svn -exec rm -rf {} ';' &>/dev/null
}

src_install() {
	local install_dir=/usr/$(get_libdir)/${PN}

	exeinto ${install_dir}
	# install executable
	doexe ${CCL_RUNTIME}
	# install core image
	cp ${CCL_RUNTIME}.image "${ED}"/${install_dir} || die
	# install optional libraries
	dodir ${install_dir}/tools
	cp tools/*fsl "${ED}"/${install_dir}/tools || die

	# until we figure out which source files are necessary for runtime
	# optional features and which aren't, we install all sources
	find . -type f -name '*fsl' -delete
	cp -a compiler level-0 level-1 lib library \
		lisp-kernel scripts tools xdump \
		"${ED}"/${install_dir} || die
	cp -a ${CCL_HEADERS} "${ED}"/${install_dir} || die

	make_wrapper ccl "${install_dir}/${CCL_RUNTIME}"

	echo "CCL_DEFAULT_DIRECTORY=${install_dir}" > "${ENVD}"
	doenvd "${ENVD}"

	dodoc doc/release-notes.txt
	dohtml doc/ccl-documentation.html
	use doc && dohtml -r examples
}
