# syntax=docker/dockerfile:1
FROM debian:latest AS build

# Install Flutter & OS dependencies.
RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get upgrade -y
RUN apt-get clean

# Create volume to cache flutter repository.
VOLUME /usr/local/flutter

FROM build AS git

# Setup git.
RUN git config --global user.name "admin@parabeac.com"
RUN git config --global user.email "admin@parabeac.com"
RUN git config --global color.ui auto
RUN git config --global --add safe.directory /usr/local/flutter

# Clone the flutter repo
# Pulling Flutter/Dart last non null-safety release, due to some Parabeac dependecies not ready for it.
RUN git clone --branch 3.7.12 https://github.com/flutter/flutter.git /usr/local/flutter

# Add Flutter and Dart to path.
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

FROM git AS main

WORKDIR /app

ADD pubspec.* /app/
RUN dart pub get

ADD . /app
RUN dart pub get --offline

# TODO(Jorgeruiz97): Compile into an executable, this will help to have a smaller container footprint.
ENTRYPOINT ["dart", "./parabeac.dart"]
