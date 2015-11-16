#!/bin/sh

security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security unlock-keychain -p travis ios-build.keychain
security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain

security import ./Lib/Certificates/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./Lib/Certificates/developer.p12 -k ~/Library/Keychains/ios-build.keychain -P $PASSPHRASE -T /usr/bin/codesign

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./Lib/Certificates/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
