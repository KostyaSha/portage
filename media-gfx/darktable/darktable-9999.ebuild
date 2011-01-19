# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit cmake-utils eutils gnome2-utils

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
KEYWORDS=""
IUSE="debug gnome gphoto2 lensfun openmp rawspeed static"

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
		lensfun? ( >=media-libs/lensfun-0.2.3 )
		gnome? ( >=gnome-base/gconf-2.26.0
				>=gnome-base/gnome-keyring-2.28.0 )"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.40.5i
		openmp? ( >=sys-devel/gcc-4.4[openmp] )"

#src_prepare() {
#	sed -e 's/^dtdoc_/#\0/g' -i Makefile.am
#	eautoreconf
#	intltoolize --force --automake --copy || die "intltoolize failed"
#	if [ ! -e configure ] ; then
#		./autogen.sh
#	fi
#}

src_configure() {
# TODO create static build for portable version
#	use static && append-ldflags -static
#	econf \
#		$(use_enable static) \
#		$(use_enable openmp) \
#		$(use_enable nls) \
#		$(use_enable lensfun) \
#		$(use_enable gnome gconf) \
#		$(use_enable gnome gkeyring) \
#		$(use_enable gnome schemas-install) \
#		$(use_enable debug)i
	mycmakeargs=(
		$(cmake-utils_use_use gnome GCONF_BACKEND) \
		$(cmake-utils_use_use openmp OPENMP) \
		$(cmake-utils_use_use gphoto2 CAMERA_SUPPORT) \
		$(cmake-utils_use_use !rawspeed DONT_USE_RAWSPEED) 
		)

	cmake-utils_src_configure
}

src_install() {
#	emake DESTDIR="${D}" install || die "emake install failed."
	cmake-utils_src_install

	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
	dodoc doc/ChangeLog doc/README doc/TODO doc/TRANSLATORS || die "dodoc failed"
}

pkg_preinst() {
	use gnome && gnome2_gconf_savelist
}

pkg_postinst() {
	use gnome && gnome2_gconf_install
}

pkg_prerm() {
	use gnome && gnome2_gconf_uninstall
}
