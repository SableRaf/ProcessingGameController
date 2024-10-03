# Base image with OpenJDK 17 (LTS version)
FROM openjdk:17-slim

# Set environment variables for Android SDK and Gradle
ENV ANDROID_SDK_ROOT=/usr/local/android-sdk
ENV GRADLE_HOME=/opt/gradle/gradle-7.6
ENV PATH="$GRADLE_HOME/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$PATH"

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Gradle 7.x (change version if necessary)
ARG GRADLE_VERSION=7.6
RUN mkdir /opt/gradle \
    && curl -fsSL https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle.zip \
    && unzip gradle.zip -d /opt/gradle \
    && rm gradle.zip

# Download and install Android SDK command line tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -o cmdline-tools.zip \
    && unzip cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm cmdline-tools.zip

# Install Android SDK packages
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "build-tools;33.0.2" "platforms;android-33"

# Set working directory
WORKDIR /usr/src/app

# Copy the library source code into the Docker image
COPY . .

# Modify the build.properties to set the correct Android SDK and sketchbook locations
RUN sed -i 's|^sketchbook.location=.*$|sketchbook.location=/usr/src/app/sketchbook|' /usr/src/app/processing/resources/build.properties \
    && sed -i 's|^android_sdk.location=.*$|android_sdk.location=/usr/local/android-sdk|' /usr/src/app/processing/resources/build.properties

# Create sketchbook directory (if needed)
RUN mkdir -p /usr/src/app/sketchbook/libraries

# Change to the processing subdirectory and run Gradle build
WORKDIR /usr/src/app/processing
RUN ${GRADLE_HOME}/bin/gradle dist

# Define the entrypoint for the Docker container
CMD ["${GRADLE_HOME}/bin/gradle", "dist"]
