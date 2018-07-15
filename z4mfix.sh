#!/usr/bin/env bash
cat <<- EOF
Hello! This is a fix script for zcash4mac application
it will download and build a new version of zcashd
from https://github.com/kozyilmaz/zcash-apple
and upgrade your zcash4mac
press enter to continue or control+c to exit 
EOF
read agree
echo "installing xcode cli.."
xcode-select --install
echo "clone and build Zcash on macOS"
git clone https://github.com/kozyilmaz/zcash-apple.git
cd zcash-apple
source environment
echo "it will take some time.."
make && {
  echo "Good!"
  z4mpath="/Applications/zcash4mac.app"
  [ ! -e $z4mpath ] && {
  echo "can't see the app folder, please select zcash4mac manually"
  z4mpath="`osascript -e 'tell application (path to frontmost application as text)
set myFile to choose file with prompt "Select zcash4mac applitaion:"
POSIX path of myFile
end'`"
  }
  echo "Fixing your problem =).."
  cp -f out/usr/local/bin/zcashd $z4mpath/Contents/Java && {
    cd ..
    rm -rf zcash-apple
    echo "Good! Enjoy!"
    open $z4mpath
  } || echo "hmm.. problem not fixed :("
} || echo "sorry, something's wrong :-("
