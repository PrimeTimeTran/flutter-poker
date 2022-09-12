#!/bin/bash

# Get flutter
git clone https://github.com/flutter/flutter.git
FLUTTER=flutter/bin/flutter

# Configure flutter
FLUTTER_CHANNEL=master
FLUTTER_VERSION=v1.17.0
$FLUTTER channel $FLUTTER_CHANNEL
$FLUTTER version $FLUTTER_VERSION
$FLUTTER config --enable-web

# Build flutter for web
$FLUTTER build web

echo "OK"