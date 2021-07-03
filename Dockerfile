FROM python:latest
LABEL maintainer="admin@mrobelix.de"
MAINTAINER mrobelix <admin@mrobelix.de>

# Update System
RUN apt-get update

# Get Streamlink
ENV streamlinkVersion=2.2.0
ADD https://github.com/streamlink/streamlink/releases/download/${streamlinkVersion}/streamlink-${streamlinkVersion}.tar.gz /opt/

# Install Streamlink
RUN tar -xzf /opt/streamlink-${streamlinkVersion}.tar.gz -C /opt/ && \
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
