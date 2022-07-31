import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:web3dart/crypto.dart';
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

Future<String> signMessageWithMetamask(
  WalletConnect connector,
  String message,
  String uri,
  SessionStatus session,
) async {
  if (connector.connected) {
    try {
      print("Message received");
      print(message);

      EthereumWalletConnectProvider provider =
          EthereumWalletConnectProvider(connector);
      launchUrlString(uri, mode: LaunchMode.externalApplication);
      var signature = await provider.personalSign(
          message: message, address: session.accounts[0], password: "");
      // print(signature);
      return signature;
    } catch (exp) {
      // print("Error while signing transaction");
      print(exp);
      return "Error Occured" + exp.toString();
    }
    ;
  } else {
    // print("Not connected");
    return "Not connected";
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
        "contractAddress": "0x3C5ff3047834EB23d7cC18cE049a1Ef6464c306B"
      },
      //Example holder for the profile address that gets created.
      //storage.setItem(
      //    'profileAddress', '0x0c9Bf82F3dA04981a5648bA2674BEF973CFBf23d');
    ]);
    storage.setItem('pendingJobs', []);
    storage.setItem('pendingNegotiations', []);
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
    BigInt _salary,
    BigInt _starttime,
    BigInt _duration) async {
  var results = await transaction(ethereumClient, storage,
      storage.getItem('walletAddress'), 'dSmarketPlace', 'createNewJob', [
    _title,
    _description,
    EthereumAddress.fromHex(storage.getItem('walletAddress')),
    _salary,
    _starttime,
    _duration,
  ]);
  return results;
}

Future<Map<String, String>> getJob(
    Web3Client ethereumClient, String jobAddress) async {
  var title =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'title', []);
  var description =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'description', []);
  var salary = await query(
      ethereumClient, jobAddress, 'dSmarketJob', 'paymentInWei', []);
  var soliciter =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'soliciter', []);
  var startTime =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'startTime', []);
  var duration =
      await query(ethereumClient, jobAddress, 'dSmarketJob', 'duration', []);
  //var status =
  //    await query(ethereumClient, jobAddress, 'GigMeJob', 'status', []);
  //var fundsReleased = await query(
  //    ethereumClient, jobAddress, 'GigMeJob', 'fundsReleased', []);

  Map<String, String> job = {
    "title": title[0].toString(),
    "description": description[0].toString(),
    "soliciter": soliciter[0].toString(),
    "salary": salary[0].toString(),
    "starttime": startTime[0].toString(),
    "duration": duration[0].toString(),
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
  String abiJson = await rootBundle.loadString("assets/abi/${abiName}.json");
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
  String abiJson = await rootBundle.loadString("assets/abi/${abiName}.json");
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
