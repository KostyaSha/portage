# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils cmake-utils git

DESCRIPTION="vlc backend for phonon"
HOMEPAGE="http://gitorious.org/phonon/phonon-vlc"
EGIT_REPO_URI="git://gitorious.org/phonon/${PN}.git"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~x86"

DEPEND=""

RDEPEND="${DEPEND}"

src_configure()	{
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}

