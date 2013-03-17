#!/bin/bash
 
#
# author: vaidas jablonskis <jablonskis at gmail dot com>
#
# script which allows to control wifi on/of, battery life extender,
# performance level for samsung series 9 laptop
#
 
# these paths should be correct by default
# if not set the variables correctly
batt_life_ext="/sys/devices/platform/samsung/battery_life_extender"
perf_level="/sys/devices/platform/samsung/performance_level"
 
# wlan rfkill name tends to change, so just to be safe
rfkill="$(grep -l "samsung-wlan" /sys/devices/platform/samsung/rfkill/rfkill*/name)"
if [[ -f "$rfkill" ]]; then
wlan_state="$(echo "$rfkill" | sed 's/name$/state/')"
fi
 
# function which toggles battery life extender on/off
batt() {
    batt_life_ext_value="$(cat $batt_life_ext)"
    if [[ $batt_life_ext_value -eq 0 ]]; then
     echo "1" > $batt_life_ext
    else
     echo "0" > $batt_life_ext
    fi
}
 
# function which toggles performance level (normal or silent)
perf() {
    perf_level_value="$(cat $perf_level)"
    if [[ "$perf_level_value" == "silent" ]]; then
     echo "normal" > $perf_level
    elif [[ "$perf_level_value" == "normal" ]]; then
     echo "silent" > $perf_level
    fi
}
 
# function which toggles wifi on/off
wlan() {
    wlan_state_value="$(cat $wlan_state)"
    if [[ $wlan_state_value -eq 0 ]]; then
     echo "1" > $wlan_state
    else
     echo "0" > $wlan_state
    fi
}
 
case "$1" in
    batt)
        batt
        ;;
    perf)
        perf
        ;;
    wlan)
        wlan
        ;;
    *)
        echo "Usage: $0 {batt|perf|wlan}"
        exit 1
esac
