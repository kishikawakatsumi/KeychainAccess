#!/bin/sh

CERT_DIR="./Lib/Certificates"
FILES=('ios_developer.p12' 'developer_id_app.p12' 'iOS_Development.mobileprovision'\
       'tvOS_Development.mobileprovision' 'KeychainAccess_Tests.provisionprofile')

for file in ${FILES[@]}; do
  openssl aes-256-cbc -k "$ENCRYPTION_SECRET" -in "$CERT_DIR"/"$file".enc -d -a -out "$CERT_DIR"/"$file"
done
