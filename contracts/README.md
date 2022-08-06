# Workflow of dSmarket

# User Stories
## Actors
1. Job Solicitor
2. Job Contractor
3. Market Administrator

* First a ```Market Administrator``` deploys a Market place using the ```dSmarketPlace``` contract.
* Next, ```Job Solicitors``` are able to post jobs to the ```dSmarketPlace``` using the ```dSmarketCreateJob``` utilitiy. This creates a job with the title, description, paymentToken (if MATIC or LINK), and then how much in wei the contract is worth.
* Next, ```Job Contractors``` are able to use the ```dSmarketNegotiationUtil``` to start a negotiation on a job with the owner of the job.
* ```Job Contractors``` and ```Job Solicitors``` use the ```dSmarketNegotiation``` to finalize terms of contract.
* Once Terms are finalized, ```Job Solicitors``` accepts the terms of the contract (the last value of the negotiation) and effectively stops new data from being added.
* The ```Job Contractor``` is given a ```dSmarketJobCompletion``` contract to track their work and notify the job owner about completion. The ```Job Solicitor``` is able to accept the completion of the job in the ```dSmarketCloseout``` contract that is created and tied to the original job.
* Once the job is completed, and the closeout is specified by the original ```Job Solicitor```, payment that was specified in the last negotiation interaction is released from the ```Job Solicitor's``` wallet, to the ```Job Contractor's``` wallet. 
* The ```Job Solicitor``` then can create a ```dSmarketRating``` that can reflect the overall appreciation of the job.
* The ```Job Contractor``` can link IPFS proofs into their ```dSmarketJobCompletion``` contract as validity of the work.

## References
1. [Polygon Getting Started](https://docs.polygon.technology/docs/develop/getting-started/) 
2. [Truffle Boxes](https://trufflesuite.com/boxes/)
3. [Ganache Local Chain](https://github.com/trufflesuite/ganache)
4. [Solidity Documents](https://docs.soliditylang.org/en/v0.8.15/)
5. [D&D Chainlink Example](https://github.com/PatrickAlphaC/dungeons-and-dragons-nft/blob/master/contracts/DungeonsAndDragonsCharacter.sol)
6. [Awesome Solidity](https://github.com/bkrem/awesome-solidity)
7. [Best ecrecover explaination ever](https://soliditydeveloper.com/ecrecover)