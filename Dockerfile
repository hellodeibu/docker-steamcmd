FROM ubuntu:18.04

LABEL Name=docker-steamcmd Version=1.0.0 Maintainer="Dave Jansen - Pretty Basic"

ENV PORT_STEAM=27015
ENV STEAMCMD_URL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
ENV USER_STEAM_ID=1000
ENV DIR_STEAMCMD=/opt/steamcmd

# For debugging purposes only
ENV DEBUGGER=

# Start by updating and installing the required packages
RUN set -ex; \
  apt-get -y update; \
  apt-get -y upgrade; \
  apt-get install -y curl lib32gcc1;

# Adjust open file limitations -- This is required for certain games, so let's set it by default
RUN ulimit -n 100000;

# Create a user and usergroup for Steam
RUN set -ex; \
  addgroup \
    -gid ${USER_STEAM_ID} \
    steam; \
  adduser \
	  --disabled-login \
	  --shell /bin/bash \
  	--gecos "" \
    --gid ${USER_STEAM_ID} \
    --uid ${USER_STEAM_ID} \
	  steam;

# Create the directory SteamCMD will live in, and set its ownership
RUN mkdir -p $DIR_STEAMCMD
RUN chown steam:steam $DIR_STEAMCMD

WORKDIR $DIR_STEAMCMD

# Make sure everything is run as the Steam user
USER steam

# Download & unpack SteamCMD
RUN curl -sqL ${STEAMCMD_URL} | tar zxfv -

# Announce the default Steam ports
# Note: You should open game-specific ports, too.
EXPOSE ${PORT_STEAM}/tcp ${PORT_STEAM}/udp

# Optional: Initial run with anonymous login
# This should stay disabled when using Docker Hub to auto-build, for example
#RUN [ "./steamcmd.sh", "+@NoPromptForPassword 1", "+login anonymous",  "+quit" ]

ENTRYPOINT [ "./steamcmd.sh" ]
