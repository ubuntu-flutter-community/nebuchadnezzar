# Nebuchadnezzar - Matrix Client written in Dart & Flutter for Linux & MacOS

## Linux setup

```
sudo apt install libsqlite3-dev libolm-dev libolm3 libcrypto++-dev libsecret-1-dev libjsoncpp-dev
```

snap TODO:
```yaml
parts:
  uet-lms:
    source: .
    plugin: flutter
    flutter-target: lib/main.dart
    build-packages:
      - libsecret-1-dev
      - libjsoncpp-dev
    stage-packages:
      - libsecret-1-0
      - libjsoncpp-dev
```

## macos setup

Assuming your project lies in "~/Projects/nebuchadnezzar"

This needs a better building, but it works for now :P

```
brew install libolm
cp /opt/homebrew/Cellar/libolm/3.2.16/lib/libolm.3.2.16.dylib ~/Projects/nebuchadnezzar/build/macos/Build/Products/Debug/nebuchadnezzar.app/Contents/Frameworks
cp /opt/homebrew/Cellar/libolm/3.2.16/lib/libolm.dylib ~/Projects/nebuchadnezzar/build/macos/Build/Products/Debug/nebuchadnezzar.app/Contents/Frameworks
cp /opt/homebrew/Cellar/libolm/3.2.16/lib/libolm.3.dylib ~/Projects/nebuchadnezzar/build/macos/Build/Products/Debug/nebuchadnezzar.app/Contents/Frameworks
cp /Users/frederik/Downloads/libcrypto.1.1.dylib ~/Projects/nebuchadnezzar/build/macos/Build/Products/Debug/nebuchadnezzar.app/Contents/Frameworks
```

### Credits: Fluffy-Chat

The bootstrap UI, the HTML message, the room permission logic and the english translations are copied and modified from the fluffy-chat repository.
Thank you for your awesome dart sdk!

### Why this name?

The name is inspired by the traveling vehicle from the movie Matrix, which uses the name of https://en.wikipedia.org/wiki/Nebuchadnezzar_II the second king of Babylon!