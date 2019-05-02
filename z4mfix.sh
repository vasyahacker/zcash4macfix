#!/usr/bin/env bash
cat <<- EOF
Hello! This is a fix script for zcash4mac application
it will download and extract a new version of zcashd
from https://github.com/ZcashFoundation/zecwallet
and help your with zcash4mac
press enter to continue or control+c to exit
EOF
read agree
[ -e ./zcashd ] || {
  echo "Downloading latest macOS-zecwallet..."
  url=`curl -s https://api.github.com/repos/ZcashFoundation/zecwallet/releases/latest \
  | grep "browser_download_url.*dmg" \
  | cut -d : -f 2,3 \
  | tr -d \"`
  echo "$url"
  curl -L -O -C - $url
  curdir=`pwd`
  echo "Mounting dmg image.."
  dmg="${url##*/}"
  mpoint=`hdiutil attach "$dmg" | tail -n1 | cut -f3`

  [ -d "$mpoint" ] || { echo "mounting error"; exit 1; }

  zcdpath="$mpoint/ZecWallet.app/Contents/MacOS/zcashd"

  [ -e "$zcdpath" ] || { echo "Can't find a zcashd at $zcdpath"; exit 1; }

  echo "Getting latest zcashd..."
  cp -f $zcdpath ./ #$z4mpath/Contents/Java

  echo "Ejecting $mpoint..."
  hdiutil detach "$mpoint"
  rm -f $dmg

}
echo "Good!"

echo "Starting zcashd and waiting 60 seconds..."
./zcashd --daemon
sleep 60

z4mpath="/Applications/zcash4mac.app"
[ ! -e $z4mpath ] && {
  echo "can't see the app folder, please select zcash4mac manually"
  z4mpath="`osascript -e 'tell application (path to frontmost application as text)
set myFile to choose file with prompt "Select zcash4mac applitaion:"
POSIX path of myFile
end'`"
}
echo "Starting zcash4mac..."
open $z4mpath

echo "Press enter to kill zcashd"
read
killall zcashd
