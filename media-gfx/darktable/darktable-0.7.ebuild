# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit autotools eutils gnome2-utils

if [[ ${PV} = 9999 ]]; then
	inherit git
	EGIT_REPO_URI="git://${PN}.git.sourceforge.net/gitroot/${PN}/${PN}"
	EGIT_BRANCH="master"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	RESTRICT="mirror"
fi

DESCRIPTION="Utility to organize and develop raw images"
HOMEPAGE="http://darktable.sourceforge.net/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gphoto2 debug gegl gnome openmp lensfun nls static"

RDEPEND="dev-db/sqlite:3
		>=dev-libs/dbus-glib-0.80
		>=gnome-base/libglade-2.6.3
		>=media-gfx/exiv2-0.18.0
		>=media-libs/openexr-1.6.0
		gphoto2? ( >=media-libs/libgphoto2-2.4.5 )
		>=media-libs/lcms-1.17
		>=media-libs/jpeg-6b-r8
		>=media-libs/libpng-1.2.0
		>=media-libs/tiff-3.9.2
		>=net-misc/curl-7.18.0
		x11-libs/cairo
		>=x11-libs/gtk+-2.18:2
		gegl? ( >=media-libs/gegl-0.0.22 )
		lensfun? ( >=media-libs/lensfun-0.2.3 )
		gnome? ( >=gnome-base/gconf-2.26.0
			>=gnome-base/gnome-keyring-2.28.0 )"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.40.5"

src_prepare() {
#	sed -e 's/^dtdoc_/#\0/g' -i Makefile.am
	eautoreconf
	intltoolize --force --automake --copy || die "intltoolize failed"
#	if [ ! -e configure ] ; then
#		./autogen.sh
#	fi
	use debug && sed -i -e 's/CURLOPT_VERBOSE, 0/CURLOPT_VERBOSE, 1/g'  "${S}"/src/imageio/storage/picasa.c
# decrease load average, not worked
#	use debug && sed -i -e '22i#define dt_ctl_get_num_procs() 0' "${S}"/src/main.c
	sed -i -e 's/EXTRA_DIST+=darktablerc//' Makefile.am
	sed -i -e 's/dtdataroot_DATA+=darktablerc//' Makefile.am
}

src_configure() {
	use static && append-ldflags -static
	econf $(use_enable static) \
		$(use_enable openmp) \
		$(use_enable nls) \
		$(use_enable lensfun) \
		$(use_enable gegl) \
		$(use_enable gphoto2) \
		$(use_enable gnome gconf) \
		$(use_enable gnome gkeyring) \
		$(use_enable gnome schemas-install) \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
	dodoc ChangeLog README TODO TRANSLATORS || die "dodoc failed"
}
