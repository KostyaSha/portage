# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PV=${PN}-$(get_version_component_range 1-3)$(get_version_component_range 5)-r$(get_version_component_range 4)

DESCRIPTION="Direct connect server with plugins support"
HOMEPAGE="http://www.verlihub-project.org"
SRC_URI="http://www.verlihub-project.org/download/${MY_PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#IUSE="lua iplog forbid funny messanger chatroom isp replacer stats python thublink"
IUSE="lua"

DEPEND="dev-libs/libpcre
		dev-libs/geoip
		>=dev-db/mysql-4.0.20
		sys-libs/zlib"
PDEPEND=" lua? ( net-libs/lua ) "
# iplog? ( net-libs/iplog )
#	  forbid? ( net-libs/forbid )
#	  funny? ( net-libs/funny )
#	  messanger? ( net-libs/messanger )
#	  chatroom? ( net-libs/chatroom )
#	  isp? ( net-libs/isp )
#	  replacer? ( net-libs/replacer )
#	  stats? ( net-libs/stats )
#	  python? ( net-libs/python )
#	  thublink? ( net-libs/thublink )
#	"

S="${WORKDIR}/${MY_PV}"

pkg_preinst() {
	enewgroup verlihub
	enewuser verlihub -1 -1 -1 verlihub
}

src_compile() {
	econf --enable-static=no || die "econf failed"
	emake || die "Make failed; please report problems or bugs \
	to bugs@verlihub-project.org or visit http://forums.verlihub-project.org/viewforum.php?f=35"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"

	diropts -o verlihub -g verlihub -m0750
	dodir /etc/verlihub || die
	keepdir /etc/verlihub || die
	diropts -o verlihub -g verlihub -m0770
	dodir /var/log/verlihub || die
	keepdir /var/log/verlihub || die

	newinitd "${FILESDIR}"/verlihub.initd verlihub || die
	newconfd "${FILESDIR}"/verlihub.confd verlihub || die

	dodoc AUTHORS ChangeLog NEWS README TODO || die

	docinto "scripts"
	dodoc \
			scripts/runhub \
			scripts/vh_getcfg \
			scripts/vh_getdb \
			scripts/vh_regnick \
			scripts/vh_restart \
			scripts/vh_runhub \
			scripts/vh_setup \
			scripts/vh_trigger || die
}

pkg_postinst() {
	echo
	ewarn "Do NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to bugs@verlihub-project.org \
		or to http://forums.verlihubproject.org/viewforum.php?f=36"
	einfo "Verlihub Project Team"

	if [[ -f "/etc/verlihub/dbconfig" ]]
	then
	einfo "Verlihub is already configured in /etc/verlihub"
	einfo "You can configure a new hub by typing:"
	ewarn "emerge --config =${CATEGORY}/${PF}"
	else
	ewarn "You MUST configure verlihub before starting it:"
	ewarn "emerge --config =${CATEGORY}/${PF}"
	ewarn "That way you can [re]configure your verlihub setup"
	fi
}

pkg_config() {
	ewarn "Configuring verlihub"
	ewarn "For using verlihub on priveleged ports change"
	ewarn "VERLIHUB_USER AND VERLIHUB_GROUP to root in /etc/conf.d/verlihub"
	/usr/bin/vh_install
	if [[ $? ]]
	then
		ewarn "You have not configured verlihub succesfully. Please try again"
	else
		ewarn "Configuration completed"
	fi
}
