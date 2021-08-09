FROM python:latest
MAINTAINER Mrobelix <admin@mrobelix.de>

# Update System
RUN apt-get update && apt-get install gosu

# Install Streamlink
RUN streamlinkVersion=$(curl -s https://api.github.com/repos/streamlink/streamlink/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
	wget -c https://github.com/streamlink/streamlink/releases/download/${streamlinkVersion}/streamlink-${streamlinkVersion}.tar.gz -P /opt && \
	tar -xzf /opt/streamlink-${streamlinkVersion}.tar.gz -C /opt/ && \
	rm /opt/streamlink-${streamlinkVersion}.tar.gz && \
	cd /opt/streamlink-${streamlinkVersion}/ && \
	python setup.py install

# Creating the directories
RUN mkdir /home/download && \
	mkdir /home/script && \
	mkdir /home/plugins

# Copy the Scripts
COPY ./streamlink-recorder.sh /home/script
COPY ./entrypoint.sh /home/script

# ENTRYPOINT
RUN ["chmod", "+x", "/home/script/entrypoint.sh"]
ENTRYPOINT [ "/home/script/entrypoint.sh" ]

# Start Streamlink
CMD /bin/sh ./home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName}