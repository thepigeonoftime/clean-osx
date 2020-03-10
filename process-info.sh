for f in /System/Library/LaunchDaemons/*; do
	echo $f
	defaults read $f
done
for f in /System/Library/LaunchAgents/*; do
	echo $f
	defaults read $f
done