# GigMe - Market Place: Polygon Blockchain Hackathon

## Problem
Let's be honest. Even with the constant discussion on how blockchain decentralizes control and gives the individual control of their assets, and thus their lives. There are really only 3 different types of dApps that seem to even get created: DeFi, Videogames, or NFT art galleries. The users of these dApps are generally already believers of crypto currency, and have financial resources to fully participate in the #cryptolife or even have the time to understand how a decentralized future would ultimately benefit both sellers and customer. There will be continued resistance, or even governing backlash without this grassroots involvement in the 

## The Solution
This dApp's concept is not revolutionary. However, the advantages, and implementation of the app in an independant, distributed and decentralized manner truly is. Simply put the dApp is market place infrastructure to coordinate requested services with service providers through the most beneficial part blockchain technologies: Smart Contracts.

In the words of Vitalik Buterin:
```md
Whereas most technologies tend to automate workers on the periphery doing menial tasks, blockchains automate away the center. Instead of putting the taxi driver out of a job, blockchain puts Uber out of a job and lets the taxi drivers work with the customer directly.
```

With this philosophy in mind, the GigMe market place allows contractors to select Gigs (like traditional gig economy) but for all types of services instead of . The smart contract infrastructure provides tangable, independantly auditable legal agreements between a person requiring work to be performed (a service requestor) and anyone that is able to provide the solution to that work at an acceptable. 

## Key Features
The app facilitates 3 major components of the ecosystem. 
1. Profile Creation
2. A Job Marketplace
3. Rating Job Performance and Dispute Reconciliation Support

## FAQs: 
1. How would I accept work from a specific contractor? (Profiles and Reviews)
2. Does this remove anonymity of blockchain? (No, you can create profiles and should realistically)
3. Does this replace apps that are currently in the same space? (No, in fact it allows them to talk to each other and lower cost by lowering their backend system O&M)
4. So then how does the app make money? (It doesn't make interacting the technology easier, instead the apps now compete on the user experience; applications can still collect data on the users, and tailored services for making certain jobs pop over others becomes comparative advantages)


### Examples
1. ```Currier Service```: A simple job of taking a package across town. Utilizing the system of Profiles (of both sender and )
2. ```Unique tasks for people trying to transition career fields```: Allows for job history of individuals to be tracked and also used as a resume builder by individuals who want to work outside of traditional employment paradigms 
3. ```Ratings for non-industry specific work```: Allows for people with parallel backgrounds to perform side job tasks that would otherwise require extensive background or references.

### Smart Contracts
For the sake of speed and development, I put everything on the same network, but would definitely change this after some intensive testing to see what the best values are for transaction costs.

Possible Layer 1
1. ```Jobs```:
2. ```JobAcceptance```:
3. ```JobCompletion```:
4. ```JobRating```:
5. ```Profiles```:

Possible Layer 2
1. ```Job Publication```:
2. ```Job Negotiation```:

## Prerequisites to running the app
1. You must have the [metamask](https://github.com/MetaMask/metamask-mobile/releases) apk to run the GigMe apk. This is because you will be using MetaMask to integrate your wallet management with the GigMe App.
2. You will need to login to MetaMask with your MetaMask Account
3. (Development Only) you will need to add in, and select the Mumbai testnet with directions that can be found [here](https://docs.polygon.technology/docs/develop/network-details/network/). I had trouble with the RPC url provided and ended up using the [https://chainlist.org/](https://chainlist.org/): ```https://rpc-mumbai.maticvigil.com```
4. You will need to fill your wallet from the Poly or Mumbai Faucet [here](https://faucet.polygon.technology/). We filled up until grey listed :). 

### Mobile App
Everyone uses a phone. The phone, and ultimately it's next wearable, will be the way the way that you will be able to officially make your will known. For the sake of this hackathon, the interaction vector will be through a mobile app.

Utilizing the [Flutter](https://flutter.dev/) framework, the development team can deploy for iOS, Android and Web Utilizing the same codebase. Big thanks to Bhaskar for the layout on how to use [Flutter with Metamask](https://dev.to/bhaskardutta/building-with-flutter-and-metamask-8h5).

```Build```
Built and Tested on Pixel 4 (API 30).

```Test```
With an Virtual device running (I used android studios AVD Laucher)
```sh
user@polygon-hackathon-submission$ cd mobile
user@mobile$ flutter run --no-sound-null-safety
# no-sound-null-safety because package:vibration needs this check
```

```Deployment```

```sh
adb push xxx
```

## Known Bugs 
1. ```Problem```: When attempting to connect to metamask, metamask will open but won't prompt for the app to ask for permission. ```Work Around```: Go back to the app and then click the "connect to metamask" button again.
2. ```Problem```: When logging out, you might not be able to log back in. ```Work Around``` close the app and log backin.

## The Team 
```Smart Contracts```
1. Atilla

```Mobile App```
1. Atilla 

## References
1. [Devpost Submission](https://devpost.com/submit-to/15647-polygon-buidl-it-summer-2022/manage/submissions)
2. [Polygon Getting Started](https://docs.polygon.technology/docs/develop/getting-started/) 
3. [Truffle Boxes](https://trufflesuite.com/boxes/)
4. [Ganache Local Chain](https://github.com/trufflesuite/ganache)
5. [Solidity Documents](https://docs.soliditylang.org/en/v0.8.15/)
6. [D&D Chainlink Example](https://github.com/PatrickAlphaC/dungeons-and-dragons-nft/blob/master/contracts/DungeonsAndDragonsCharacter.sol)
7. [Awesome Solidity](https://github.com/bkrem/awesome-solidity)
8. [Awesome Flutter](https://github.com/Solido/awesome-flutter)
9. [Developing Metamask App with Flutter](https://github.com/BhaskarDutta2209/FlutterAppWithMetamask)
10. [Flutter dApp](https://www.geeksforgeeks.org/flutter-and-blockchain-hello-world-dapp/)
11. [Ethereum Dart Developer](https://ethereum.org/en/developers/docs/programming-languages/dart/)

## Thanks to
1. BhaskarDutta - For the awesome tutorial for linking up metamask with flutter applications!