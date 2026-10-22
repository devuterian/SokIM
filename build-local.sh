#!/bin/zsh
# 로컬 빌드·서명·설치. 서명 인증서는 ~/.config/marierie-codesign (레포 밖)에 있음.
set -e
cd "${0:A:h}"
xcodebuild -project SokIM.xcodeproj -scheme SokIM -configuration Release -derivedDataPath /tmp/SokIM-build CODE_SIGNING_ALLOWED=NO build | tail -1
KC=~/Library/Keychains/marierie-codesign.keychain-db
security unlock-keychain -p "$(cat ~/.config/marierie-codesign/kc.pass)" $KC
A=/tmp/SokIM-build/Build/Products/Release/SokIM.app
codesign -f --deep -s B115B5D96C8A594CFCDD08DB0537F23F1B5C153D --keychain $KC --entitlements SokIM/SokIM-local.entitlements $A
TS=$(date +%Y%m%d-%H%M%S)
osascript -e "do shell script \"mv '/Library/Input Methods/SokIM.app' '$HOME/.Trash/SokIM-old-$TS.app' && ditto '$A' '/Library/Input Methods/SokIM.app' && chown -R root:wheel '/Library/Input Methods/SokIM.app'\" with administrator privileges"
pkill -x SokIM || true
open -g "/Library/Input Methods/SokIM.app"
