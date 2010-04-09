# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2
# ebuild for darktable by jo hanika (hanatos@gmail.com)
inherit autotools eutils gnome2-utils

DESCRIPTION="Utility to organize and develop raw images"
HOMEPAGE="http://darktable.sf.net/"
if [ ${PV} = 9999 ]; then
	inherit git
	EGIT_REPO_URI="git://darktable.git.sf.net/gitroot/darktable/darktable"
	EGIT_BRANCH="master"
else
	SRC_URI="mirror://sourceforge.net/${PN}/${P}.tar.bz2"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gegl gnome openmp lensfun nls"
DEPEND="
	>=x11-libs/gtk+-2.18.0
	>=gnome-base/libglade-2.6.3
	>=dev-db/sqlite-3.6.11
	>=x11-libs/cairo-1.8.6
	gegl? ( >=media-libs/gegl-0.0.22 )
	>=media-libs/lcms-1.17
	>=media-libs/jpeg-6b-r8
	>=media-gfx/exiv2-0.18.1
	>=media-libs/libpng-1.2.38
	>=dev-util/intltool-0.40.5
	lensfun? ( >=media-libs/lensfun-0.2.4 )
	gnome? ( >=gnome-base/gconf-2.24.0 )
	>=media-libs/tiff-3.9.2
"
RDEPEND="${DEPEND}"

src_configure() {
	eautoreconf
	econf --enable-static=no \
		$(use_enable openmp) \
		$(use_enable nls) \
		$(use_enable lensfun) \
		$(use_enable gegl) \
		$(use_enable gnome gconf) \
		$(use_enable gnome schemas-install)
}

src_compile() {
	emake -j1 || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc README TODO
}
