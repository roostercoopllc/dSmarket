### dSmarket Mobile App
Everyone uses a phone. The phone, and ultimately it's next wearable interface/device, will be the way the way that you will be able to officially make your accept your jobs, publish needs, and crowd source recommendations for your best lifestyle. For the sake of this hackathon, the interaction vector will be through a mobile app on an android device. However, the device can be deployed on android, ios, and through any browser.

Utilizing the [Flutter](https://flutter.dev/) framework, the development team can deploy for iOS, Android and Web Utilizing the same codebase. Big thanks to Bhaskar for the layout on how to use [Flutter with Metamask](https://dev.to/bhaskardutta/building-with-flutter-and-metamask-8h5).

```Build```
Built and Tested on Pixel 4 (API 30).

```Test```
With an Virtual device running (I used android studios AVD Laucher)
```sh
user@polygon-hackathon-submission$ cd dApp
user@dApp$ flutter run -v 
```

```Deployment```
```sh
flutter build android
adb push xxx 
```

## Prerequisites to running the app
1. You must have the [metamask](https://github.com/MetaMask/metamask-mobile/releases) apk to run the GigMe apk. This is because you will be using MetaMask to integrate your wallet management with the GigMe App.
2. You will need to login to MetaMask with your MetaMask Account
3. (Development Only) you will need to add in, and select the Mumbai testnet with directions that can be found [here](https://docs.polygon.technology/docs/develop/network-details/network/). I had trouble with the RPC url provided and ended up using the [https://chainlist.org/](https://chainlist.org/): ```https://rpc-mumbai.maticvigil.com```
4. You will need to fill your wallet from the Poly or Mumbai Faucet [here](https://faucet.polygon.technology/). We filled up until grey listed :).


## Known Bugs 
1. ```Problem```: When attempting to connect to metamask, metamask will open but won't prompt for the app to ask for permission. ```Work Around```: Go back to the app and then click the "connect to metamask" button again.
2. ```Problem```: When logging out, you might not be able to log back in. ```Work Around``` close the app and log backin.

## References
1. [Awesome Flutter](https://github.com/Solido/awesome-flutter)
2. [Developing Metamask App with Flutter](https://github.com/BhaskarDutta2209/FlutterAppWithMetamask)
3. [Flutter dApp](https://www.geeksforgeeks.org/flutter-and-blockchain-hello-world-dapp/)
4. [Ethereum Dart Developer](https://ethereum.org/en/developers/docs/programming-languages/dart/)
5. [Good Web3Dart Example with ABI Interaction](https://github.com/MCarlomagno/fluthereum/blob/master/lib/main.dart)
6. [Cert Generation for iOS app](https://stackoverflow.com/questions/20445365/create-pkcs12-file-with-self-signed-certificate-via-openssl-in-windows-for-my-a)



## Thanks to
1. BhaskarDutta - For the awesome tutorial for linking up metamask with flutter applications!