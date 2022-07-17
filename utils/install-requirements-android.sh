echo "Installing the Metamask apk from GitHub"
wget https://github.com/MetaMask/metamask-mobile/releases/download/v5.3.0/app-release.apk -O metamask.apk
adb install metamask.apk
rm metamask.apk

echo "Installing the Flutter apk from GitHub"
wget https://.../GigMe-1.0.1-release.apk -o gigme.apk
adb install gigme.apk
rm gigme.apk