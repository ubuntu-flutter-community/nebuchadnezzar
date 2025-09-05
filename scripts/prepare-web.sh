#!/bin/sh -ve

git clone https://github.com/famedly/dart-vodozemac.git .vodozemac
cd .vodozemac
cargo install flutter_rust_bridge_codegen
flutter_rust_bridge_codegen build-web --dart-root dart --rust-root $(readlink -f rust) --release
cd ..
rm -f ./assets/vodozemac/vodozemac_bindings_dart*
mkdir ../assets/vodozemac
mv .vodozemac/dart/web/pkg/vodozemac_bindings_dart* ../assets/vodozemac/
rm -rf .vodozemac