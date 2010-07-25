# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils qt4

DESCRIPTION="KDE dropbox client and gui"
HOMEPAGE="http://dropbox.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

LANGS="cs  en  es  fr  it  lt  pl  ru  si  tr  zh"
for i in ${LANGS}; do
		IUSE="${IUSE} linguas_${i}"
done

DEPEND="x11-libs/qt-gui"
RDEPEND="${DEPEND}"

src_configure() {
	qconf || die "qcond failed"
}

src_compile() {
	eqmake4
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	exeinto /usr/bin
	doexe bin/kdropbox || dir "failed to install kdropbox"
	if [[ -n ${LINGUAS} ]]; then
		insinto /usr/share/locale/LC_MESSAGES
		for l in ${LANGS}; do
			use linguas_${l} && \
					doins ${l}/kdropbox.po
			done
	fi
	
#	make_desktop_entry kdropbox "xyscan data point extractor"
}
