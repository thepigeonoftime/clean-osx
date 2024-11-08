#!/bin/bash

## CleanMojave.sh ##
## A script to unload unnecessary LaunchAgents and LaunchDaemons from MacOS 10.14 ##
## run with 'restore' argument to reload daemons (bash cleanmojave.sh restore) ##

################################################"
##        DO NOT RUN THIS SCRIPT BLINDLY       #"
##         YOU'LL PROBABLY REGRET IT...        #"
##                                             #"
##              READ IT THOROUGHLY             #"
##         AND EDIT TO SUIT YOUR NEEDS         #"
################################################"


## Uncomment LaunchAgents/LaunchDaemons to unload: ##

# https://gist.github.com/pwnsdx/d87b034c4c0210b988040ad2f85a68d3#gistcomment-2701248
# https://github.com/meson10/mac_tej/blob/master/nos.sh
#

LaunchAgents=(
/System/Library/LaunchAgents/com.apple.mediaremoteagent.plist #iTunes related
# /System/Library/LaunchAgents/com.apple.assistant_service.plist
# /System/Library/LaunchAgents/com.apple.assistantd.plist
# /System/Library/LaunchAgents/com.apple.AssistiveControl.plist
# /System/Library/LaunchAgents/com.apple.imagent.plist
/System/Library/LaunchAgents/com.apple.CommCenter-osx.plist
/System/Library/LaunchAgents/com.apple.sharingd.plist
/System/Library/LaunchAgents/com.apple.SSInvitationAgent.plist
/System/Library/LaunchAgents/com.apple.videosubscriptionsd.plist
/System/Library/LaunchAgents/com.apple.avconferenced.plist
/System/Library/LaunchAgents/com.apple.telephonyutilities.callservicesd.plist
)
LaunchDaemons=(
/System/Library/LaunchDaemons/com.apple.mediaremoted.plist #hangs itunes if disabled
/System/Library/LaunchDaemons/com.apple.cmio.iOSScreenCaptureAssistant.plist
/System/Library/LaunchDaemons/com.apple.comsat.plist
/System/Library/LaunchDaemons/com.apple.racoon.plist
/System/Library/LaunchDaemons/com.apple.remotepairtool.plist
/System/Library/LaunchDaemons/ntalk.plist
)

load() {
	if [[ $testrun == "true" ]]; then
		echo rename 's/\.bak$//' ${@}
		echo launchctl load -w ${@}
		echo sudo launchctl load -w ${@}
		echo -e "\n \n"
	else
		(set -x; sudo rename 's/\.bak$//' "${@}.bak";
		launchctl load -w ${@};
		sudo launchctl load -w ${@};)
		# grep launchctl list output to check if service is really enabled
		sudo launchctl list | grep $(echo "${@}" | /usr/bin/sed -E 's/.*\/(.*).plist/\1/')
		if [[ "$?" -eq 0 ]]; then
			echo "[OK] Agent ${@} enabled"
		fi
		echo -e "\n \n"
	fi
}



for service in "${LaunchAgents[@]}"
do
	load ${service}
done

for service in "${LaunchDaemons[@]}"
do
	load ${service}
done
