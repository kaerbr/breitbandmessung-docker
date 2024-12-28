# Use jlesage's GUI base image
FROM jlesage/baseimage-gui:ubuntu-22.04-v4

# Set internal environment variables
RUN set-cont-env APP_NAME "Breitbandmessung"
ENV APP_VERSION=3.7.0
RUN set-cont-env APP_VERSION $APP_VERSION
RUN set-cont-env DOCKER_IMAGE_VERSION $APP_VERSION

# Set public environment variables
ENV TZ=Europe/Berlin
# 1180x720 is absolute minimum
ENV DISPLAY_WIDTH=1280
ENV DISPLAY_HEIGHT=768
# Set timely boundries for execution
ENV START_HOUR=13
ENV START_MINUTE=00
ENV END_HOUR=22
ENV END_MINUTE=30

# Install packages
RUN apt update && apt upgrade -yy && \
  apt install -y libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libgbm-dev libxss1 libasound2 wget xterm libnss3 xdotool xclip && \
  rm -rf /var/cache/apt /var/lib/apt/lists

RUN wget -O /tmp/breitbandmessung.deb https://download.breitbandmessung.de/bbm/Breitbandmessung-${APP_VERSION}-linux.deb && \
    echo "1a0473f87779580f3815ee0c310f7717f77f3892a62b30a5686a5d7df0907282 /tmp/breitbandmessung.deb" | sha256sum -c - && \
    apt-get install -y /tmp/breitbandmessung.deb && \
    rm /tmp/breitbandmessung.deb

# Generate and install favicons.
RUN install_app_icon.sh "https://www.breitbandmessung.de/public/images/appicon-512.png"

# Copy the start/run script
COPY startapp.sh /startapp.sh

# Copy the speedtest script
COPY run.sh /etc/services.d/default/run

# Expose required port for GUI access
EXPOSE 5800
