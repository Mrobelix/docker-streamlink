#!/bin/bash

# For more information visit: https://github.com/downthecrop/TwitchVOD

while [ true ]; do
		cd /home/download
		ls -1t | tail -n +8 | xargs -d '\n' rm -f
		
		Date=$(date +%Y%m%d-%H%M%S)
		streamlink $streamOptions $streamLink $streamQuality -o /home/download/$streamName"-$Date".mkv
		sleep 60s
done
