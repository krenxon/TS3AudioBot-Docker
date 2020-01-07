ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
FROM $REPO:2.2-stretch-slim
MAINTAINER CookieCr2nk
LABEL description="TS3Audiobot Dockerized"
#Install requires
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg curl wget unzip libopus-dev python && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Install .NET Core
ENV DOTNET_VERSION 2.2.8

RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='b818557b0090ec047be0fb2e5ffee212e23e8417e1b0164f455e3a880bf5b94967dc4c86d6ed82397af9acc1f7415674904f6225a1abff85d28d2a6d5de8073b' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

#YT-DL Herunterladen
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl

# TS3Audiobot installieren
WORKDIR /app
RUN wget -O TS3AudioBot.zip https://splamy.de/api/nightly/ts3ab/master_dotnet_core/download && unzip TS3AudioBot.zip && rm -f TS3AudioBot.zip
VOLUME /app
#Portfreigabe
EXPOSE 58913

#TS3Audiobot starten
 CMD ["dotnet", "TS3AudioBot.dll", "--non-interactive"]
