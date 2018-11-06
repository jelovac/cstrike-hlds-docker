FROM debian:stable-slim


ARG steam_user=anonymous
ARG steam_password=


RUN apt update && apt install -y lib32gcc1 curl


# Install SteamCMD
RUN mkdir -p /opt/steam && cd /opt/steam && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -


# Install HLDS
RUN \
    mkdir -p /opt/hlds \
    && echo "Workaround for \"app_update 90\" bug, see https://forums.alliedmods.net/showthread.php?p=2518786" \
    && /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 90 validate +quit \
    && /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 70 validate +quit || : \
    && /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 10 validate +quit || : \
    && /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 90 validate +quit \
    && mkdir -p ~/.steam && ln -s /opt/hlds ~/.steam/sdk32 \
    && ln -s /opt/steam/ /opt/hlds/steamcmd \
    && echo "10" > /opt/hlds/steam_appid.txt
COPY scripts/hlds_run.sh /usr/local/bin/hlds_run


# Add default config
COPY files/server.cfg /opt/hlds/cstrike/server.cfg


# Add default maps
VOLUME ["/opt/hlds/cstrike/maps"]
COPY maps/* /opt/hlds/cstrike/maps/
COPY files/mapcycle.txt /opt/hlds/cstrike/mapcycle.txt


# Install metamod
RUN mkdir -p /opt/hlds/cstrike/addons/metamod/dlls
RUN curl -sqL "http://prdownloads.sourceforge.net/metamod/metamod-1.20-linux.tar.gz?download" | tar -C /opt/hlds/cstrike/addons/metamod/dlls -zxvf -
COPY files/liblist.gam /opt/hlds/cstrike/liblist.gam
# Remove this line if you aren't going to install/use amxmodx and dproto
COPY files/plugins.ini /opt/hlds/cstrike/addons/metamod/plugins.ini


# Install dproto
RUN mkdir -p /opt/hlds/cstrike/addons/dproto
COPY files/dproto_i386.so /opt/hlds/cstrike/addons/dproto/dproto_i386.so
COPY files/dproto.cfg /opt/hlds/cstrike/dproto.cfg


# Install AMX mod X
RUN curl -sqL "http://www.amxmodx.org/release/amxmodx-1.8.2-base-linux.tar.gz" | tar -C /opt/hlds/cstrike/ -zxvf -
RUN curl -sqL "http://www.amxmodx.org/release/amxmodx-1.8.2-cstrike-linux.tar.gz" | tar -C /opt/hlds/cstrike/ -zxvf -
COPY files/maps.ini /opt/hlds/cstrike/addons/amxmodx/configs/maps.ini


WORKDIR /opt/hlds
ENTRYPOINT ["hlds_run"]