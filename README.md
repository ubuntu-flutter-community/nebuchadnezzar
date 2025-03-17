# Nebuchadnezzar - Matrix Client written in Dart & Flutter for Linux

## Install

[![Get it from the Snap Store](https://snapcraft.io/en/dark/install.svg)](https://snapcraft.io/nebuchadnezzar)

![light](.github/images/light.png)

## Build yourself

### Linux setup

#### Install flutter

[How to install flutter](https://docs.flutter.dev/get-started/install)

#### Install system dev libraries for persistence, encryption and notifications

```
sudo apt install libsqlite3-dev libolm-dev libolm3 libcrypto++-dev libsecret-1-dev libjsoncpp-dev libnotify-dev
```

#### Run

`flutter run`

or

`sudo snap install code --classic`

&

[vscode dart extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)


### macos setup (for development)

Assuming your project lies in "~/Projects/nebuchadnezzar"

This needs a better building, but it works for now :P

```
brew install libolm
cp /opt/homebrew/Cellar/libolm/3.2.16/lib/libolm.3.2.16.dylib ~/Projects/nebuchadnezzar/build/macos/Build/Products/Debug/nebuchadnezzar.app/Contents/Frameworks
cp /opt/homebrew/Cellar/libolm/3.2.16/lib/libolm.dylib ~/Projects/nebuchadnezzar/build/macos/Build/Products/Debug/nebuchadnezzar.app/Contents/Frameworks
cp /opt/homebrew/Cellar/libolm/3.2.16/lib/libolm.3.dylib ~/Projects/nebuchadnezzar/build/macos/Build/Products/Debug/nebuchadnezzar.app/Contents/Frameworks
cp /Users/frederik/Downloads/libcrypto.1.1.dylib ~/Projects/nebuchadnezzar/build/macos/Build/Products/Debug/nebuchadnezzar.app/Contents/Frameworks
```

## Credits: Fluffy-Chat

The bootstrap UI, the HTML message, the room permission logic and the english translations are copied and modified from the fluffy-chat repository.
Thank you for your awesome dart sdk!

## Why this name?

The name is inspired by the traveling vehicle from the movie Matrix, which uses the name of https://en.wikipedia.org/wiki/Nebuchadnezzar_II the second king of Babylon!
