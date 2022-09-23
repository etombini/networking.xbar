#!/usr/bin/env bash

# <xbar.title>Networking information</xbar.title>
# <xbar.version>v0.0.1</xbar.version>
# <xbar.author>Elvis Tombini</xbar.author>
# <xbar.author.github>etombini</xbar.author.github>
# <xbar.desc>Display various network information</xbar.desc>

# Most of the code comes from 
# https://xbarapp.com/docs/plugins/Network/wifisignal.sh.html

# Themes copied from here: http://colorbrewer2.org/
# shellcheck disable=SC2034
RED_GREEN_THEME=("#d73027" "#fc8d59" "#fee08b" "#d9ef8b" "#91cf60" "#1a9850")
COLORS=("${RED_GREEN_THEME[@]}")

DATE="$(date -Iminutes)"
WIFIDATA=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)
SSID=$(echo "$WIFIDATA" | awk '/ SSID/ {print substr($0, index($0, $2))}')
SIGNAL=$(echo "$WIFIDATA" | awk '/ agrCtlRSSI/ {print substr($0, index($0, $2))}')
NOISE=$(echo "$WIFIDATA" | awk '/ agrCtlNoise/ {print substr($0, index($0, $2))}')

SNR="$((SIGNAL - NOISE))"

IP="$(curl https://ifconfig.me/ip)"
PING_1_1_1_1="$(ping -c 5 -n -q  1.1.1.1 |grep round)"
PING_PI01="$(ping -c 5 -n -q pi01 |grep round)"


# Signal Strength – 0dBm (strongest) and --100dBm (weakest). 
## -30 dBm  Amazing
## -50 dBm	Excellent
## -60 dBm	Good
## -67 dBm	Reliable
## -70 dBm	Okay
## -80 dBm	Not Good
## -90 dBm	Unusable
if (("$SIGNAL" >= -30)); then
    RATING="Amazing"
    COLOR=${COLORS[6]}
elif (("$SIGNAL" >= -50)); then
    RATING="Excellent"
    COLOR=${COLORS[5]}
elif (("$SIGNAL" >= -60)); then
    RATING="Good"
    COLOR=${COLORS[4]}
elif (("$SIGNAL" >= -67)); then
    RATING="Reliable"
    COLOR=${COLORS[3]}
elif (("$SIGNAL" >= -70)); then
    RATING="Okay"
    COLOR=${COLORS[2]}
elif (("$SIGNAL" >= -80)); then
    RATING="Not Good"
    COLOR=${COLORS[1]}
elif (("$SIGNAL" >= -90)); then
    RATING="Unusable"
    COLOR=${COLORS[0]}
else
    RATING="Unknown"
    COLOR="#ccc"
fi

# Signal Quality - quality ~= 2* (dBm + 100)
## High quality: 90% ~= -55dBm
## Medium quality: 50% ~= -75dBm
## Low quality: 30% ~= -85dBm
## Unusable quality: 8% ~= -96dBm
QUALITY="$((2 * SNR))"
QUALITY="$((QUALITY < 100 ? QUALITY : 100))"

echo "ᯤ | color=$COLOR"
echo "---"
echo "$DATE"
echo "---"
echo "SSID: $SSID"
echo "Signal: $SIGNAL dbM ($RATING)"
echo "Quality: $QUALITY% ($SNR dBm SNR)"
echo "Public IP: $IP"
echo "---"
echo "ping"
echo "1.1.1.1: $PING_1_1_1_1"
echo "pi01: $PING_PI01"
echo "---"
echo "Refresh... | refresh=true"

