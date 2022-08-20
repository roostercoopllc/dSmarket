import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:localstorage/localstorage.dart';

String truncateString(String text, int front, int end) {
  int size = front + end;

  if (text.length > size) {
    String finalString =
        "${text.substring(0, front)}...${text.substring(text.length - end)}";
    return finalString;
  }

  return text;
}

String getNetworkName(int chainId) {
  switch (chainId) {
    case 1:
      return 'Ethereum Mainnet';
    case 3:
      return 'Ropsten Testnet';
    case 4:
      return 'Rinkeby Testnet';
    case 5:
      return 'Goreli Testnet';
    case 42:
      return 'Kovan Testnet';
    case 137:
      return 'Polygon Mainnet';
    case 80001:
      return 'Mumbai Testnet';
    default:
      return 'Unknown Chain';
  }
}

bool startLocalStorage(LocalStorage storage) {
  if (storage.getItem('initialized') == null) {
    storage.setItem('initialized', true);
    // These are all good demo addresses as defaults.
    storage.setItem(
        'walletAddress', '0x0000000000000000000000000000000000000000');
    storage.setItem('contracts', [
      {
        "contractName": "dSmarketPlace",
        "contractAddress": "0x2aEA5b24ab6ad08ba5C1E0664AC7DF3633C693D3",
        "ipfsAbiAddress": ""
      },
      {
        "contractName": "dSmarketNegotiationUtil",
        "contractAddress": "0xFc96d8e17F3DD8408e08c386f63c4e8A54478C18",
        "ipfsAbiAddress": ""
      },
      {
        "contractName": "dSmarketCreateJob",
        "contractAddress": "0xaDd25A3C72C7ecC589f71F71989f2e102ea7BE82",
        "ipfsAbiAddress": ""
      },
      {
        "contractName": "dSmarketCheckout",
        "contractAddress": "0x19CF5eD14F0b6b93Cf4e9F2f2696Df89b89b0Bf0",
        "ipfsAbiAddress": ""
      },
      //Example holder for the profile address that gets created.
      //storage.setItem(
      //    'profileAddress', '0x0c9Bf82F3dA04981a5648bA2674BEF973CFBf23d');
    ]);
    storage.setItem('pendingJobs', []);
    storage.setItem('pendingNegotiations', []);
    storage.setItem('exchanges', [
      {
        "name": "Ledger",
        "url": "https://www.ledger.com/buy",
        "logo":
            "https://cryptoast.fr/wp-content/uploads/2021/03/ledger-logo.png"
      },
      {
        "name": "Crypto.com",
        "url": "https://crypto.com/",
        "logo":
            "https://cdn-images-1.medium.com/max/1200/1*XFp-x1Le4CosNrU4t2pl3g.png"
      },
      {
        "name": "Coinbase",
        "url": "https://www.coinbase.com/",
        "logo":
            "https://yt3.ggpht.com/a/AATXAJw3PkjDymHkoh35r3mJNBX1p0JGH-AutrBktQ=s900-c-k-c0xffffffff-no-rj-mo"
      }
    ]);
    storage.setItem(
        'demoProfile', '0x3bE5B5d37d1920fFfceFC949A780b1565f518e21');
    storage.setItem('demoJobs', []);
  }
  return storage.getItem('initialized');
}

TextEditingController controller = TextEditingController();

String polygonClientUrl =
    'https://polygon-mumbai.infura.io/v3/a4377cb55c9340f5a731d51c05fc0f22';

Future<List<dynamic>> query(Web3Client ethereumClient, String address,
    String contractName, String functionName, List<dynamic> args) async {
  DeployedContract contract = await getContract(address, contractName);
  ContractFunction function = contract.function(functionName);
  List<dynamic> result = await ethereumClient.call(
      contract: contract, function: function, params: args);
  return result;
}

Future<List<dynamic>> queryFromStorage(
    Web3Client ethereumClient,
    LocalStorage storage,
    String contractName,
    String functionName,
    List<dynamic> args) async {
  DeployedContract contract =
      await getContractFromStorage(storage, contractName);
  ContractFunction function = contract.function(functionName);
  List<dynamic> result = await ethereumClient.call(
      contract: contract, function: function, params: args);
  return result;
}

Future<String> transaction(
    Web3Client ethereumClient,
    LocalStorage storage,
    String address,
    String contractName,
    String functionName,
    List<dynamic> args) async {
  EthPrivateKey credential =
      EthPrivateKey.fromHex(storage.getItem('cheaterPrivateKey'));
  DeployedContract contract = await getContract(address, contractName);
  // print(contract);
  ContractFunction function = contract.function(functionName);
  dynamic result = await ethereumClient.sendTransaction(
    credential,
    Transaction.callContract(
      contract: contract,
      function: function,
      parameters: args,
    ),
    fetchChainIdFromNetworkId: true,
    chainId: null,
  );

  return result;
}

Future<String> transactionFromStorage(
    Web3Client ethereumClient,
    LocalStorage storage,
    String contractName,
    String functionName,
    List<dynamic> args) async {
  EthPrivateKey credential =
      EthPrivateKey.fromHex(storage.getItem('cheaterPrivateKey'));
  DeployedContract contract =
      await getContractFromStorage(storage, contractName);
  print(contract);
  ContractFunction function = contract.function(functionName);
  dynamic result = await ethereumClient.sendTransaction(
    credential,
    Transaction.callContract(
      contract: contract,
      function: function,
      parameters: args,
    ),
    fetchChainIdFromNetworkId: true,
    chainId: null,
  );

  return result;
}

Future<String> createJob(
    Web3Client ethereumClient,
    LocalStorage storage,
    String _title,
    String _description,
    BigInt _paymentToken,
    BigInt _paymentInWei) async {
  EthereumAddress marketAddress = EthereumAddress.fromHex(
      storage.getItem('contracts')[0]['contractAddress']);
  var results = await transaction(ethereumClient, storage,
      storage.getItem('walletAddress'), 'dSmarketCreateJob', 'createNewJob', [
    marketAddress,
    _title,
    _description,
    _paymentToken,
    _paymentInWei,
  ]);
  return results;
}

Future<String> createNegotiation(
    Web3Client ethereumClient,
    LocalStorage storage,
    String _jobId,
    String _description,
    BigInt _paymentToken,
    BigInt _paymentInWei) async {
  var results = await transaction(
      ethereumClient,
      storage,
      storage.getItem('walletAddress'),
      'dSmarketNegotiationUtil',
      'startNegotiation', [
    _jobId,
    _description,
    _paymentToken,
    _paymentInWei,
  ]);
  return results;
}

// TODO: Add a function to get the job details from the jobId.
Future<String> updateNegotiation(
    Web3Client ethereumClient, LocalStorage storage, String jobAddress) async {
  var results = await transaction(
      ethereumClient,
      storage,
      storage.getItem('walletAddress'),
      'dSmarketNegotiationUtil',
      'updateNegotiation', [
    jobAddress,
    storage.getItem('walletAddress'),
  ]);
  return results;
}

Future<Map<String, String>> getJob(
    Web3Client ethereumClient, String jobAddress) async {
  var title =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'title', []);
  var description =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'description', []);
  var paymentType = await query(
      ethereumClient, jobAddress, 'dSmarketJob', 'getPaymentTypeAddress', []);
  var paymentInWei = await query(
      ethereumClient, jobAddress, 'dSmarketJob', 'paymentInWei', []);
  /*
  var startTime =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'startTime', []);
  var duration =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'duration', []);
  var status =
      await query(ethereumClient, jobAddress, 'GigMeJob', 'status', []);
  var fundsReleased = await query(
      ethereumClient, jobAddress, 'GigMeJob', 'fundsReleased', []);
      */
  var tokenName = 'MATIC';
  if (paymentType[0] == '0x70d1F773A9f81C852087B77F6Ae6d3032B02D2AB') {
    tokenName = 'LINK';
  }
  Map<String, String> job = {
    "title": title[0].toString(),
    "description": description[0].toString(),
    "paymentType": tokenName,
    "paymentInWei": paymentInWei[0].toString(),
    /*"starttime": startTime[0].toString(),
    "duration": duration[0].toString(),*/
    "address": jobAddress,
  };
  return job;
}

// rework
Future<Map<String, String>> getProfile(
    Web3Client ethereumClient, LocalStorage storage, String jobAddress) async {
  var alias = await queryFromStorage(
      ethereumClient, storage, 'dSmarketProfile', 'profileAlias', []);
  var firstname = await queryFromStorage(
      ethereumClient, storage, 'dSmarketProfile', 'firstname', []);
  var lastname = await queryFromStorage(
      ethereumClient, storage, 'dSmarketProfile', 'lastname', []);
  var contactValue = await queryFromStorage(
      ethereumClient, storage, 'dSmarketProfile', 'contactValue', []);

  Map<String, String> profile = {
    "title": alias[0].toString(),
    "description": firstname[0].toString(),
    "soliciter": lastname[0].toString(),
    "salary": contactValue[0].toString(),
    "address": jobAddress,
  };
  return profile;
}

Future<Map<String, String>> getJobFromMarket(
    Web3Client ethereumclient, LocalStorage storage, int index) async {
  var jobAddress = await query(
      ethereumclient,
      getContractAddressFromStorage(storage, 'dSmarketPlace'),
      'dSmarketPlace',
      'availableJobs',
      [BigInt.from(index)]);
  var job = await getJob(ethereumclient, jobAddress[0].toString());
  job['jobAddress'] = jobAddress[0].toString();
  return job;
}

// Rework this
Future<void> createProfile(Web3Client ethereumClient, LocalStorage storage,
    String _alias, String _contactValue) async {
  var results = await transactionFromStorage(ethereumClient, storage,
      'GigMeCreateJobProfileUtil', 'createNewGigMeProfile', [
    _alias,
    _contactValue,
  ]);
  print(results);
}

Future<DeployedContract> getContract(String address, String abiName) async {
  String abiJson = await rootBundle.loadString("assets/abi/${abiName}.abi");
  String contractAddress = address;
  // print(contractAddress);
  DeployedContract contract = DeployedContract(
    ContractAbi.fromJson(abiJson, abiName),
    EthereumAddress.fromHex(contractAddress),
  );

  return contract;
}

Future<DeployedContract> getContractFromStorage(
    LocalStorage storage, String abiName) async {
  print(abiName);
  String abiJson = await rootBundle.loadString("assets/abi/${abiName}.abi");
  String contractAddress = getContractAddressFromStorage(storage, abiName);
  print(contractAddress);
  DeployedContract contract = DeployedContract(
    ContractAbi.fromJson(abiJson, abiName),
    EthereumAddress.fromHex(contractAddress),
  );
  return contract;
}

String getContractAddressFromStorage(LocalStorage storage, String abiFileName) {
  String contractAddress = 'Abi file not found';
  storage.getItem('contracts').forEach((element) {
    if (element['contractName'] == abiFileName) {
      contractAddress = element['contractAddress'].toString();
    }
  });
  return contractAddress;
}
