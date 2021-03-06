#!/usr/bin/env bash
#
# This script assumes a linux environment

echo "*** uBlock0.firefox: Copying files"

DES=dist/build/uBlock0.firefox
rm -rf $DES
mkdir -p $DES

bash ./tools/make-assets.sh $DES

cp -R src/css                           $DES/
cp -R src/img                           $DES/
cp -R src/js                            $DES/
cp -R src/lib                           $DES/
cp -R src/_locales                      $DES/
cp    src/*.html                        $DES/

# AMO review feedback: avoid "unnecessary files or folders" in package
cat   src/background.html | sed -e '/vapi-polyfill\.js/d' > $DES/background.html

mv    $DES/img/icon_128.png             $DES/icon.png
cp    platform/firefox/css/*            $DES/css/
cp    platform/firefox/polyfill.js      $DES/js/
cp    platform/firefox/vapi-*.js        $DES/js/
cp    platform/firefox/bootstrap.js     $DES/
cp    platform/firefox/frame*.js        $DES/
cp -R platform/firefox/img              $DES/
cp    platform/firefox/chrome.manifest  $DES/
cp    platform/firefox/install.rdf      $DES/
cp    platform/firefox/*.xul            $DES/
cp    LICENSE.txt                       $DES/

echo "*** uBlock0.firefox: Generating meta..."
python tools/make-firefox-meta.py $DES/

if [ "$1" = all ]; then
    set +v
    echo "*** uBlock0.firefox: Creating package..."
    pushd $DES/ > /dev/null
    zip ../uBlock0.firefox.xpi -qr *
    popd > /dev/null
fi

echo "*** uBlock0.firefox: Package done."
