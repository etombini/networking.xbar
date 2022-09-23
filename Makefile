PATH := "$HOME/Library/Application Support/xbar/plugins"

TARGETS:

install: netinfo.sh
	$(shell cp netinfo.sh "${HOME}/Library/Application Support/xbar/plugins/netinfo.5m.sh")
