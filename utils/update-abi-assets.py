import json
import os

contracts = [
  'dSmarketPlace',
  'dSmarketCreateJob',
  'dSmarketJob',
  'dSmarketCompletion',
  'dSmarketCloseout',
  'dSmarketCheckout',
  'dSmarketRating',
  'dSmarketNegotiation',
  'dSmarketNegotiationUtil'
]

for contract in contracts:
  with open(f'../contracts/artifacts/{contract}_metadata.json') as f:
    abi = json.load(f)
    abi = abi['output']['abi']
    with open(f'../dApp/assets/abi/{contract}.abi', 'w') as f:
      f.write(json.dumps(abi, indent=2))
    print(f'{contract}.abi updated')