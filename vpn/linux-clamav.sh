#!/bin/bash

# In this cisco anyconnect scriptlet, we will pretend to be running chromeos.
#
# Requirements:
# - have xmlstarlet
# - have curl
# - valid SSL on VPN endpoint
# - set the following in `/etc/openssl/openssl.conf`:

# openssl_conf = openssl_init
# 
# [openssl_init]
# ssl_conf = ssl_sect
# 
# [ssl_sect]
# system_default = system_default_sect
# 
# [system_default_sect]
# Options = UnsafeLegacyRenegotiation

printf "user: %s/%s args: %s\n" "$(id -un)" "$(id -gn)" "$*"
env | grep '^CSD' | xargs

# gather args passed to script
shift

TICKET=
STUB=0
TOKEN=
PINNEDPUBKEY="${CSD_SHA256:+"--no-check-certificate --pinnedpubkey sha256//$CSD_SHA256"}"

while [ "$1" ]; do
	if [ "$1" == "-ticket" ]; then
		shift
		TICKET=${1//\"/}
	fi
	if [ "$1" == "-stub" ]; then
		shift
		STUB=${1//\"/}
	fi
	shift
done

function get_token() {
	URL="https://$CSD_HOSTNAME/+CSCOE+/sdesktop/token.xml?ticket=$TICKET&stub=$STUB"
	if [ -n "$XMLSTARLET" ]; then
		# TOKEN=$(curl $PINNEDPUBKEY -s "$URL" | xmlstarlet sel -t -v /hostscan/token)
		TOKEN=$(wget -O- $PINNEDPUBKEY --quiet "$URL" | xmlstarlet sel -t -v /hostscan/token)
	else
		# TOKEN=$(curl $PINNEDPUBKEY -s "$URL" | sed -n '/<token>/s^.*<token>\(.*\)</token>^\1^p')
		TOKEN=$(wget -O- $PINNEDPUBKEY --quiet "$URL" | sed -n '/<token>/s^.*<token>\(.*\)</token>^\1^p')
	fi
}

function send_response() {
	COOKIE_HEADER="Cookie: sdesktop=$TOKEN"
	CONTENT_HEADER="Content-Type: text/xml"
	URL="https://$CSD_HOSTNAME/+CSCOE+/sdesktop/scan.xml?reusebrowser=1"
	# curl ${PINNEDPUBKEY} -s -H "$CONTENT_HEADER" -H "$COOKIE_HEADER" -H 'Expect: ' --data-binary @- "$URL"
	wget ${PINNEDPUBKEY} --quiet --header "$CONTENT_HEADER" --header "$COOKIE_HEADER" --header 'Expect: ' --post-data "$(cat /dev/stdin)" "$URL"
}

function check_xmlstarlet() {
	if ! xmlstarlet --version >/dev/null 2>&1; then
		echo "************************************************************************" >&2
		echo "WARNING: xmlstarlet not found in path; ${1}" >&2
		echo "************************************************************************" >&2
		unset XMLSTARLET
		return 1
	fi
}

function fake_clamav() {
	cat <<EOF
endpoint.process["freshclam-abs"].path="/usr/bin/freshclam";
endpoint.process["freshclam-abs"].exists="true";
endpoint.process["freshclam-abs"].name="freshclam";
endpoint.process["clamav-abs"].name="clamd";
endpoint.process["clamav-abs"].path="/usr/sbin/clamd";
endpoint.process["clamav-abs"].exists="true";
endpoint.process.clamav.exists="true";
EOF
}

function fake_anyconnect_macos_intel() {
	cat <<EOF
endpoint.application.clienttype="AnyConnect";
endpoint.anyconnect.platform="mac-intel";
endpoint.policy.location="Default";
endpoint.device.protection="none";
endpoint.device.protection_version="3.1.03103";
endpoint.device.protection_extension="3.6.4900.2";
EOF
}

function fake_anyconnect_linux_intel() {
	cat <<EOF
endpoint.application.clienttype="AnyConnect";
endpoint.anyconnect.platform="linux-64";
endpoint.policy.location="Default";
endpoint.device.protection="none";
endpoint.device.protection_version="3.1.03103";
endpoint.device.protection_extension="3.6.4900.2";
EOF
}

function fake_generic_linux() {
	cat <<EOF
endpoint.application.clienttype="AnyConnect";
endpoint.anyconnect.platform="linux-64";
endpoint.policy.location="Default";
endpoint.device.protection="none";
endpoint.device.protection_version="3.1.03103";
endpoint.device.protection_extension="3.6.4900.2";
endpoint.os.version="Linux";
endpoint.os.servicepack="5.4.0-96-generic";
endpoint.os.architecture="x86_64";
endpoint.device.hostname="$(hostname)";
endpoint.device.MAC["FFFF.FFFF.FFFF"]="true";
EOF
}

function fake_generic_macos() {
	cat <<EOF
endpoint.application.clienttype="AnyConnect";
endpoint.anyconnect.platform="mac-intel";
endpoint.policy.location="Default";
endpoint.device.protection="none";
endpoint.device.protection_version="3.1.03103";
endpoint.device.protection_extension="3.6.4900.2";
endpoint.os.version="Darwin";
endpoint.os.servicepack="21.2.0";
endpoint.os.architecture="x86_64";
endpoint.device.hostname="$(hostname)";
endpoint.device.MAC["FFFF.FFFF.FFFF"]="true";
EOF
}

function fake_firewall() {
	cat <<EOF
endpoint.fw["IPTablesFW"]={};
endpoint.fw["IPTablesFW"].exists="true";
endpoint.fw["IPTablesFW"].description="IPTables (Linux)";
endpoint.fw["IPTablesFW"].version="1.6.1";
endpoint.fw["IPTablesFW"].enabled="ok";
EOF
}

function fake_ports() {
	cat <<EOF
endpoint.device.port["53"]="true";
endpoint.device.port["22"]="true";
endpoint.device.port["631"]="true";
endpoint.device.port["445"]="true";
endpoint.device.tcp4port["53"]="true";
endpoint.device.tcp4port["22"]="true";
endpoint.device.tcp4port["631"]="true";
endpoint.device.tcp4port["445"]="true";
endpoint.device.tcp6port["53"]="true";
endpoint.device.tcp6port["22"]="true";
endpoint.device.tcp6port["631"]="true";
endpoint.device.tcp6port["445"]="true";
EOF
}

function real_generic() {
	# use this with a fake_anyconnect function
	cat <<EOF
endpoint.os.version="$(uname -s)";
endpoint.os.servicepack="$(uname -r)";
endpoint.os.architecture="$(uname -m)";
endpoint.device.hostname="$(hostname)";
endpoint.device.MAC["FFFF.FFFF.FFFF"]="true";
EOF
}

function run_hostscan() {
	check_xmlstarlet "hostscan requests will be skipped" || return 0

	URL="https://${CSD_HOSTNAME}/CACHE/sdesktop/data.xml"

	# curl $PINNEDPUBKEY -s "$URL" | xmlstarlet sel -t -v '/data/hostscan/field/@value' | while read -r ENTRY; do
	wget -O- $PINNEDPUBKEY --quiet "$URL" | xmlstarlet sel -t -v '/data/hostscan/field/@value' | while read -r ENTRY; do
		# XX: How are ' and , characters escaped in this?
		TYPE="$(sed "s/^'\(.*\)','\(.*\)','\(.*\)'$/\1/" <<<"$ENTRY")"
		NAME="$(sed "s/^'\(.*\)','\(.*\)','\(.*\)'$/\2/" <<<"$ENTRY")"
		VALUE="$(sed "s/^'\(.*\)','\(.*\)','\(.*\)'$/\3/" <<<"$ENTRY")"

		if [ "$TYPE" != "$ENTRY" ]; then
			echo "Unhandled hostscan field '$ENTRY'"
			continue
		fi

		case "$TYPE" in
		Process)
			EXISTS=false
			pidof "${VALUE}" &>/dev/null && EXISTS=true
			cat <<EOF
endpoint.process["$NAME"]={};
endpoint.process["$NAME"].name="$VALUE";
endpoint.process["$NAME"].exists="$EXISTS";
EOF
			## XX: Add '.path' if it's running?
			;;
		File)
			BASENAME="$(basename "$VALUE")"
			cat <<EOF
endpoint.file["$NAME"]={};
endpoint.file["$NAME"].path="$VALUE";
endpoint.file["$NAME"].name="$BASENAME";
EOF
			TS=$(stat -c %Y "$VALUE" 2>/dev/null)
			if [ "$TS" = "" ]; then
				cat <<EOF
endpoint.file["$NAME"].exists="false";
EOF
			else
				LASTMOD=$(($(date +%s) - $TS))
				cat <<EOF
endpoint.file["$NAME"].exists="true";
endpoint.file["$NAME"].lastmodified="$LASTMOD";
endpoint.file["$NAME"].timestamp="$TS";
EOF
				CRC32=$(crc32 "$VALUE")
				if [ "$CRC32" != "" ]; then
					cat <<EOF
endpoint.file["$NAME"].crc32="0x$CRC32";
EOF
				fi
			fi
			;;
		Registry)
			# We silently ignore registry entry requests
			;;
		*)
			echo "Unhandled hostscan element of type '$TYPE': '$NAME'/'$VALUE'"
			;;
		esac
	done
}

get_token

(
	cat <<EOF
endpoint.application.clienttype="AnyConnect";
endpoint.process["freshclam-abs"].exists="true";
endpoint.process["clamav-abs"].exists="true";
endpoint.anyconnect.platform="linux-64";
EOF
	# real_generic
	# fake_anyconnect_linux_intel
	# fake_firewall
	# fake_clamav
) | tee /dev/stderr | send_response
