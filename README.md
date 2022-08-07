# dSmarket - The Decentralized Smart Contract Market Place: Polygon Blockchain

## Inspiration
Let's be honest. Even with the constant discussion on how blockchain decentralizes control and gives the individual control of their assets, and thus their lives. There are really only 3 different types of dApps that seem to even get created: DeFi, Videogames, or NFT art galleries. The users of these dApps are generally already believers of crypto currency, and have financial resources to fully participate in the #cryptolife or even have the time to understand how a decentralized future would ultimately benefit both sellers and customer. There will be continued resistance, or even governing backlash without this grassroots involvement in the adoption of crypto in leu of cash for goods and services. 

This dApp's concept is not revolutionary. However, the advantages, and implementation of the app in an independant, distributed and decentralized manner truly are. Simply put the dApp is market place infrastructure to coordinate requested services with service providers through the most beneficial part blockchain technologies: Smart Contracts.

In the words of Vitalik Buterin:
```
Whereas most technologies tend to automate workers on the periphery doing menial tasks, blockchains automate away the center. Instead of putting the taxi driver out of a job, blockchain puts Uber out of a job and lets the taxi drivers work with the customer directly.
```

With this philosophy in mind, the dSmarketPlace market place allows contractors to select Gigs/Jobs (like traditional gig economy) but for all types of services instead of having to go through a centralized, often non-democratic, corporation that arbatraily takes their cut off the top. The smart contract infrastructure of dSmarket provides tangable, independantly auditable legal agreement between a person requiring work to be performed (a service requestor) and anyone that is able to provide the solution to that work at an acceptable. 

## What it does
For the most up-to-date documentation please look at the [Smart Contracts](contracts/README.md) for the Smart Contract Dicussion, [dApp Documentation](dApp/README.md) for the discussion on the UI/UX.

The app facilitates 4 major components of the ecosystem. 
1. A Job MarketPlace. This managable contract allows for a broker to focus contracts for specific markets, specialized collectives of goods and services, or simply connect people with needs with those that can fulfill them.
2. Profiles and history for both Contractors (People doing work) and Solicitors (People Wanting Work). This allows for individuals to audit the hsitory of the contracts of people that they interact with. While the profiles can simply be a wallet, and effectively be a number on a sheet, those anonymous address can have assigned history and quality of work so that people purchase the goods and services based on the repuation of the profile and not simply a name, or having to have high levels of risk for unknown quantities.
3. Rating Job Performance and Dispute Reconciliation Support by having a self notarizing negotiations and Completion history. The ratings of the jobs go to both the speed at which job solicitors pay their contracts, and how well the contractor completes the services. This effectively, and implicitly build in a reputation to price ratio that helps the best work fetch the best price.
4. Facilitating directions to crypto exchanges to buy, exchange, or manage your crypto through the MetaMask connector. This marketplace partnership with different exhcanges allow for solicitors to buy crypto to solicit jobs, and for contractors to cash out their crypto for cash (until the future day where this step is made obsolete by governments inflating fiat until it is no longer a viable means of commerce).

### Examples of Jobs supported
Example jobs that are created for this demo are the following:

1. ```Currier Service```: A simple job of taking a package across town. Utilizing the system of Profiles (of both sender and )
2. ```Unique tasks for people trying to transition career fields```: Allows for job history of individuals to be tracked and also used as a resume builder by individuals who want to work outside of traditional employment paradigms 
3. ```Ratings for non-industry specific work```: Allows for people with parallel backgrounds to perform side job tasks that would otherwise require extensive background or references.

However, these types of jobs are not the only ones that could be supported by this infrastructure. Existing companies can minimize their backend costs by switiching the storage and solicitation of services through infrastructure like this. Moreover, people could implicitly benefit from the communication with the contract through their app without requiring everyone to use it (meaning people that don't want to use the app can connect with people using the app thus keeping more people on the app instead of forcing the contractors to leave to a new app in order to perform commerce). 

There are also non-profit groups that could benefit from this app. For example, US Veterans can request services for mental heath support, va loan advice, or other services and those services can be searched by groups that provide those services. And visa-versa. 

I will discuss the monetization aspect of the dApp infrastructure later in the README.

### FAQs: 
1. How would I accept work from a specific contractor?
Answer: Should the need arise to know the contractor face to face, the profile feature of the app allows for "digital identification" to be verified through scanning the qr code. A contractor, when showing up to a house can open his or her app, and have the solicitor scan the app to prove identity. 
2. Does this remove anonymity of blockchain?
Answer: Not really. While I am sure there will oneday be a need to register wallets for tax purposes. There is no reason why a person cannot create multiple profiles. And those profiles can each have their own ratings. For example, the high a rating for a profile contract is, the more likly it is that they stay around and continue to bid jobs under that contract, while if another contractor has a lower score, that score doesn't have to stay with them forever if they improve their skills or craft in general. The major risk will always be on the solicitor on which contractor that they accept. 
3. Does this replace apps that are currently in the same space? 
Answer: No, in fact the opposite. Ultimately, everyone is accessing the same service market. This not only expands their potential business base, but it also lowers their operating costs since the majority of the backend interactions are handled by the decentized system.
4. So then how does the app make money? 
Answer: The apps that will be the most profitiable will be the ones that make their users live's easier. This means that the app market then is how to best use the "market ecosystem" to easily create verbage for and post jobs; find jobs; negotiate the best rates; accept jobs; and handle the financial portions of this exchange the cheapest and easiest for the user. Moreover, the ability to manage money with exchanges leads to easy avenues for strategic partnerships and mutual profitiablity. 

## How we built it
We started with some fun brainstorming sessions over Discord, since we are all remote workers with hecktic schedules and had to basically play "tag" for any coordination that took place. 

For the actual code, I wanted to use the maximum amount of plugins with VSCode to natively develop the entire project. This ultimately led to running the remix daemon through VSCode. While I wished there was a "browser" to use inside of vscode for all the github co-pilot interactions that I have recently enjoyed, I simply used the browser for the smartcontract development.

For flutter, which I have had very little experience with in doing a project of this scale, I relied heavily on the web4dart library, which has a depricated library, and no real answer on if the library will be used in the future. There are also some example code options using walletconnect but didn't really make the smart contract interactions as easy from what I could tell. I absolutely loved how the same code base could be used out of the box for web, mobile, and desktop applications (Fuscia I am coming for you).

I used github projects for the project management aspects, and also used github actions for the down-and-dirty ci/cd that really does need to be redone if this really takes off. 

## Challenges we ran into
I found alot of fun design paradigms in making the contracts. I ultimately submitted the project without people actually being able to transact in their token of choice simply because the app is buggy enough as it is, I don't want to be responsible for someone giving away their token (even if it is dev token) through the app since I ran out of time. 

I am also interested in exploring the legal aspects of the app. For example, this application doesn't "handle" the interactions for the contractors (like how Uber facilitates all apsects of the rides). With my paradigm, individuals can transact in a way that has all of the artifacts they could take to court to prove they entered into a legal agreement with someone, without the app ever having to "employ" any of the 3rd party contractors. 

## Accomplishments that we're proud of
We learned alot, I definitely was able to stretch my understanding of both Solidity, Flutter, and the #Cryptolife in general. I explored alot of other contest winners projects, marking concerns, and defi standards. Anything good about this project is definitely because I am standing on the shoulders of giants. 

Ultimately, having a usable app to accomplish it's set out goal while not compromising the day job, family relationships, or general health was a huge win!

## What we learned
Most people I know consider blockchain a solution without a problem. The more I dive into the technology, the more I know that I am able to accomplish tasks with trasnparent cost (which is mega tiny now), and put that code out, not only in a repository, but in a usable state. 

I learned alot about flutter since it's the new hotness that I want to use more for alot of project ideas I have. 

I learned alot about how CI/CD paradigms will likely need to be adapted to have a "good state" to develop against on development chains. I also learned alot of tricks that I can't wait to tell my interns about as they will learn about web3 technologies to set them up for success in their future careers. 

## What's next for dSmarket
Do more testing, since the app was defo rushed. I think there is a huge market for making crypto more accessable. If you want to know the market strategy: hit me up! 

I keep going back and forth between offloading the abi references to IPFS, but I would also like to have stored artifacts that would lead to interactions to take place offline and then register next time that the wallet his some connectivity. This could lead to other fun social solutions to technical problems like the advancements of mesh networks in cities like Baltimore that fill in the gaps where simple services like internet connectivity don't have a firm hold. 

There are a few more interactions in the smart contracs that I would like to flush out and then I can definitely see that becoming the defacto standard of business in a couple of markets. 

Short answer: Big Plans! but you need to pay to play baby!

## The Team 
```Smart Contracts```
1. Atilla

```Mobile App```
1. Atilla 
2. Evo

## References
1. [Devpost Submission](https://devpost.com/submit-to/15647-polygon-buidl-it-summer-2022/manage/submissions)
