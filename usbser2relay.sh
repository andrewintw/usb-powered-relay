#! /bin/sh

# USB relay module: LCUS-1 (http://images.100y.com.tw/pdf_file/57-LCUS-1.pdf)
#
# Test Command:
#     $ sudo /bin/sh -c "echo -n -e '\xA0\x01\x01\xA2' > /dev/ttyUSB1" # ON
#     $ sudo /bin/sh -c "echo -n -e '\xA0\x01\x00\xA1' > /dev/ttyUSB1" # OFF

HEX_CODE_ON='\xA0\x01\x01\xA2'
HEX_CODE_OFF='\xA0\x01\x00\xA1'
ROOT_UID=0

serdev="$1"
op="$2"
argv="$#"

usage() {
	cat <<EOF

Usage: $0 <path_to_tty_device> <0|1>
       0: Turn the Relay ON
       1: Turn the Relay OF

EX: $0 /dev/ttyUSB1 0

EOF
}

do_init() {
	if [ "$UID" -ne "$ROOT_UID" ] ;then
		echo "Warning: you should run the script with root permission!"
		#exit 1
	fi

	if [ "$argv" != "2" ] || [ "$op" = "" ]; then
		usage
		exit 1
	fi

	if [ ! -c "$serdev"  ]; then
		cat << EOF

Error: There is no device node: ${serdev}
       Make sure USB-to-TTL driver is loaded! (ex: usbserial,pl2303)

EOF
		exit 1
	fi
}

hex2ser() {
	local action="$1"
	if [ "$action" = "ON" ]; then
		sudo /bin/sh -c "echo -n -e '$HEX_CODE_ON' > /dev/ttyUSB1"
	else
		sudo /bin/sh -c "echo -n -e '$HEX_CODE_OFF' > /dev/ttyUSB1"
	fi
}

ser2relay() {
	case "$op" in
	1|[Oo][Nn])
		hex2ser "ON"
		;;
	0|[Oo][Ff][Ff])
		hex2ser "OFF"
		;;
	*)
		usage
		exit 1
		;;
	esac
}

do_main() {
	do_init && \
	ser2relay
}

do_main
