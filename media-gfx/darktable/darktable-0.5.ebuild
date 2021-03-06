# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2
# ebuild for darktable by jo hanika (hanatos@gmail.com)
# rewrited by Kostya 'integer' Sha <gentoo.integer@gmail.com>
# i'm not using gnome, so don't know how to install schemas
inherit autotools eutils gnome2-utils

if [ ${PV} = 9999 ]; then
	inherit git
	EGIT_REPO_URI="git://darktable.git.sourceforge.net/gitroot/darktable/${PN}"
	EGIT_BRANCH="master"
else
	SRC_URI="mirror://sourceforge.net/${PN}/${P}.tar.bz2"
fi

DESCRIPTION="Utility to organize and develop raw images"
HOMEPAGE="http://darktable.sourceforge.net/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gegl gnome openmp lensfun nls"

COMMON_DEPEND="
	>=x11-libs/gtk+-2.18:2
	>=gnome-base/libglade-2.6.3
	>=dev-db/sqlite-3.6.11
	>=x11-libs/cairo-1.8.6
	gegl? ( >=media-libs/gegl-0.0.22 )
	>=media-libs/lcms-1.17
	>=media-libs/jpeg-6b-r8
	>=media-gfx/exiv2-0.18.1
	>=media-libs/libpng-1.2.38
	lensfun? ( >=media-libs/lensfun-0.2.4 )
	gnome? ( >=gnome-base/gconf-2.24.0 )
	>=media-libs/tiff-3.9.2"
DEPEND="${COMMON_DEPEND} >=dev-util/intltool-0.40.5"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	sed -e 's/^dtdoc_/#\0/g' -i Makefile.am
	intltoolize --force --automake --copy || die "intltoolize failed"
	eautoreconf
#	if [ ! -e configure ] ; then
#		./autogen.sh
#	fi
}

src_configure() {
	econf --disable-static \
		$(use_enable openmp) \
		$(use_enable nls) \
		$(use_enable lensfun) \
		$(use_enable gegl) \
		$(use_enable gnome gconf) \
		$(use_enable gnome schemas-install)
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
	dodoc ChangeLog README TODO TRANSLATORS || die "dodoc failed"
}
