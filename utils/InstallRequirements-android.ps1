echo "Installing the Metamask apk from GitHub"
Invoke-WebRequest -Uri https://github.com/MetaMask/metamask-mobile/releases/download/v5.3.0/app-release.apk -OutFile metamask.apk
adb install metamask.apk
rm metamask.apk

echo "Installing the Flutter apk from GitHub"
Invoke-WebRequest -Uri https://.../GigMe-1.0.1-release.apk -OutFile gigme.apk
adb install gigme.apk
rm gigme.apk