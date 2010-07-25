# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="The 0pen Free Fiasco Firmware Flasher"
HOMEPAGE="http://nopcode.org/0xFFFF/?p=down"
SRC_URI="http://nopcode.org/0xFFFF/get/0xFFFF-0.4.0.tar.gz"

LICENSE="GPL3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"	
#	dodoc README CHANGES || die
}
