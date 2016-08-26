#!/bin/sh

security create-keychain -p travis build.keychain
security default-keychain -s build.keychain
security unlock-keychain -p travis build.keychain
security set-keychain-settings -t 3600 -l ~/Library/Keychains/build.keychain

security import ./Lib/Certificates/apple.cer -k ~/Library/Keychains/build.keychain -T /usr/bin/codesign
security import ./Lib/Certificates/ios_developer.p12 -k ~/Library/Keychains/build.keychain -P $PASSPHRASE -T /usr/bin/codesign
security import ./Lib/Certificates/developer_id_app.p12 -k ~/Library/Keychains/build.keychain -P $PASSPHRASE -T /usr/bin/codesign

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./Lib/Certificates/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
cp ./Lib/Certificates/*.provisionprofile ~/Library/MobileDevice/Provisioning\ Profiles/
