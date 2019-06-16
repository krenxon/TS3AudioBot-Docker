FROM debian:stretch-slim
MAINTAINER CookieCr2nk<cookiecrafthd1@gmail.com>
LABEL description="TS3Audiobot Docker Image."
# Install requires
RUN apt-get update && apt-get install -y ffmpeg wget unzip gpg libopus-dev python nano

#Register Microsoft key and feed
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN wget -q https://packages.microsoft.com/config/debian/9/prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list

#.dotnet runtime 2.2 Installieren
RUN apt-get install apt-transport-https -y
RUN apt-get update
RUN apt-get install aspnetcore-runtime-2.2 -y
RUN rm -rf /var/lib/apt/lists/*

#YT-DL Herunterladen
RUN wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl

# TS3Audiobot Instanz erstellen
WORKDIR /app
VOLUME /app
RUN wget -O TS3AudioBot.zip https://splamy.de/api/nightly/ts3ab/develop_dotnet_core/download && unzip TS3AudioBot.zip && rm -f TS3AudioBot.zip

#Portfreigabe
EXPOSE 58913

#Healthcheck
HEALTHCHECK &{["CMD-SHELL" "curl -f http://localhost:5813/ || exit 1"] "1m0s" "5s" "0s" '\x00'} 
 
#TS3Audiobot starten
CMD ["dotnet", "/app/TS3AudioBot.dll", "--non-interactive"]
