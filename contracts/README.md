# Workflow of dSmarket

# User Stories
## Actors
1. Job Solicitor
2. Job Contractor
3. Market Administrator

## Workflow
* First a ```Market Administrator``` deploys a Market place using the ```dSmarketPlace``` contract.
* Next, ```Job Solicitors``` are able to post jobs to the ```dSmarketPlace``` using the ```dSmarketCreateJob``` utilitiy. This creates a job with the title, description, paymentToken (if MATIC or LINK), and then how much in wei the contract is worth.
* Next, ```Job Contractors``` are able to use the ```dSmarketNegotiationUtil``` to start a negotiation on a job with the owner of the job.
* ```Job Contractors``` and ```Job Solicitors``` use the ```dSmarketNegotiation``` to finalize terms of contract.
* Once Terms are finalized, ```Job Solicitors``` accepts the terms of the contract (the last value of the negotiation) and effectively stops new data from being added.
* The ```Job Contractor``` is given a ```dSmarketJobCompletion``` contract to track their work and notify the job owner about completion. The ```Job Solicitor``` is able to accept the completion of the job in the ```dSmarketCloseout``` contract that is created and tied to the original job.
* Once the job is completed, and the closeout is specified by the original ```Job Solicitor```, payment that was specified in the last negotiation interaction is released from the ```Job Solicitor's``` wallet, to the ```Job Contractor's``` wallet. 
* The ```Job Solicitor``` then can create a ```dSmarketRating``` that can reflect the overall appreciation of the job.
* The ```Job Contractor``` can link IPFS proofs into their ```dSmarketJobCompletion``` contract as validity of the work.
* The ```Job Solicitor``` then certfies the acceptance of the completion contract, and executes the payment originally agreed upon. 
** Note In the event that a solicitor doesn't perform a completion, the contracts allow for full visibility into the negotiation, terms of service, and completion of the project where (currently) a court could compel the solicitor (if known) to release the funds from their wallet or another owned wallet. This can ultimately lead to an automated arbitration that could assist workers to get paid for their services.


## Currently Deployed Example Contracts:
The deployment of the contracts are currently on the ```Mumbai: Polygon Test Network```. The addresses are currently 
### dSmarketPlace
```
contractAddress: 0x2aEA5b24ab6ad08ba5C1E0664AC7DF3633C693D3
PolygonScan Link: https://mumbai.polygonscan.com/address/0x2aEA5b24ab6ad08ba5C1E0664AC7DF3633C693D3
```

### dSmarketNegotiationUtil
```
contractAddress: 0xFc96d8e17F3DD8408e08c386f63c4e8A54478C18
PolygonScan Link: https://mumbai.polygonscan.com/address/0xFc96d8e17F3DD8408e08c386f63c4e8A54478C18
```

### dSmarketCreateJob
```
contractAddress: 0xaDd25A3C72C7ecC589f71F71989f2e102ea7BE82
PolygonScan Link: https://mumbai.polygonscan.com/address/0xaDd25A3C72C7ecC589f71F71989f2e102ea7BE82
```

### dSmarketCheckout
```
contractAddress: 0x19CF5eD14F0b6b93Cf4e9F2f2696Df89b89b0Bf0
PolygonScan Link: https://mumbai.polygonscan.com/address/0x19CF5eD14F0b6b93Cf4e9F2f2696Df89b89b0Bf0
```

### dSmarketJob
```
Name: Currier Example 
PolygonScan Link: https://mumbai.polygonscan.com/tx/0xd6a8188fc0f9771a91ddfebd3246f5f6c6e4b659522d304f36d3f13a61874cbd

Name: Mobile App Testing
PolygonScan Link: https://mumbai.polygonscan.com/tx/0x3fc2f865bc5d38f06c06b0e737e295726d99f3331399b80c34af4e3011d07925

Name: Fence Repair
PolygonScan Link: https://mumbai.polygonscan.com/tx/0xe58e79072c7a94df6fd042b8e0975aa9ec0544fa03a06fa7d79c051668c82a9f
```

### dSmarketProfiles
```
Name: Demo Profile
PolygonScan: https://mumbai.polygonscan.com/address/0x3bE5B5d37d1920fFfceFC949A780b1565f518e21
```

### dSmarketNegotiation
```
contractAddress: 
PolygonScan Link:
```


## References
1. [Polygon Getting Started](https://docs.polygon.technology/docs/develop/getting-started/) 
2. [Truffle Boxes](https://trufflesuite.com/boxes/)
3. [Ganache Local Chain](https://github.com/trufflesuite/ganache)
4. [Solidity Documents](https://docs.soliditylang.org/en/v0.8.15/)
5. [D&D Chainlink Example](https://github.com/PatrickAlphaC/dungeons-and-dragons-nft/blob/master/contracts/DungeonsAndDragonsCharacter.sol)
6. [Awesome Solidity](https://github.com/bkrem/awesome-solidity)
7. [Best ecrecover explaination ever](https://soliditydeveloper.com/ecrecover)