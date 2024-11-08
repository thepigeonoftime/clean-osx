#!/bin/bash
sudo rename 's/\.bak$//' /System/Library/LaunchAgents/*
sudo rename 's/\.bak$//' /System/Library/LaunchDaemons/*
for agent in /System/Library/LaunchAgents/*; do
	launchctl load -w ${agent}
	sudo launchctl load -w ${agent}
done
for daemon in /System/Library/LaunchDaemons/*; do
	launchctl load -w /${daemon}
	sudo launchctl load -w ${daemon}
done
