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

String generateSessionMessage(String accountAddress) {
  String message =
      'Hello $accountAddress, welcome to our app. By signing this message you agree to learn and have fun with blockchain';
  print(message);

  var hash = keccakUtf8(message);
  final hashString = '0x${bytesToHex(hash).toString()}';

  return hashString;
}

Map<String, String> getNegotiations(String accountAddress) {
  return {};
}

Map<String, String> getJobs(String accountAddress) {
  return {};
}

Map<String, String> getJobReviews(String accountAddress) {
  return {};
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
        "contractName": "GigMeProfile",
        "contractAddress": "0xd9145CCE52D386f254917e481eB44e9943F39138"
      },
      {
        "contractName": "GigMeJobMarketplace",
        "contractAddress": "0x2771c8f932524695c8364f01F52e0bb049A1074f"
      },
      //Example holder for the profile address that gets created.
      //storage.setItem(
      //    'profileAddress', '0x0c9Bf82F3dA04981a5648bA2674BEF973CFBf23d');
    ]);
    storage.setItem('pendingJobs', []);
    storage.setItem('pendingNegotiations', []);
    storage.setItem(
        'demoProfile', '0x3bE5B5d37d1920fFfceFC949A780b1565f518e21');
    storage.setItem('demoJobs', [
      '0x81b4cEa98fa2bf4B3A56E3727283D4d0626c257b',
      '0xD3553DDb5dCC19326276DE74250B062283fDca7D',
      '0x396d2f67BffB372C0A83e89aD06be7B50036820C'
    ]);
  }
  return storage.getItem('initialized');
}

TextEditingController controller = TextEditingController();

String polygonClientUrl =
    'https://polygon-mumbai.infura.io/v3/a4377cb55c9340f5a731d51c05fc0f22';

Future<List<dynamic>> query(Web3Client ethereumClient, String address,
    String contractName, String functionName, List<dynamic> args) async {
  // print('Ethereum Client: ${ethereumClient}');
  DeployedContract contract = await getContract(address, contractName);
  // print('Contract: ${contract.function(functionName)}');
  ContractFunction function = contract.function(functionName);
  // print('Function: ${function.name}');
  // print(ethereumClient);
  List<dynamic> result = await ethereumClient.call(
      contract: contract, function: function, params: args);
  // print('Result: ${result}');
  return result;
}

Future<List<dynamic>> queryFromStorage(
    Web3Client ethereumClient,
    LocalStorage storage,
    String contractName,
    String functionName,
    List<dynamic> args) async {
  // print('Ethereum Client: ${ethereumClient}');
  DeployedContract contract =
      await getContractFromStorage(storage, contractName);
  // print('Contract: ${contract.function(functionName)}');
  ContractFunction function = contract.function(functionName);
  // print('Function: ${function.name}');
  // print(ethereumClient);
  List<dynamic> result = await ethereumClient.call(
      contract: contract, function: function, params: args);
  // print('Result: ${result}');
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
  // print('Making a new Job Posting');
  var results = await transaction(ethereumClient, storage,
      storage.getItem('walletAddress'), 'GigMeCreateJobUtil', 'createNewJob', [
    _title,
    _description,
    EthereumAddress.fromHex(storage.getItem('walletAddress')),
    _salary,
    _starttime,
    _duration,
  ]);
  // Then push to the marketplace
  return results;
}

Future<Map<String, String>> getJob(
    Web3Client ethereumClient, String jobAddress) async {
  var title = await query(ethereumClient, jobAddress, 'GigMeJob', 'title', []);
  var description =
      await query(ethereumClient, jobAddress, 'GigMeJob', 'description', []);
  var salary =
      await query(ethereumClient, jobAddress, 'GigMeJob', 'salary', []);
  var soliciter =
      await query(ethereumClient, jobAddress, 'GigMeJob', 'soliciter', []);
  var startTime =
      await query(ethereumClient, jobAddress, 'GigMeJob', 'startTime', []);
  var duration =
      await query(ethereumClient, jobAddress, 'GigMeJob', 'duration', []);
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
    // "address": jobAddress,
  };
  // print('Returning Job');
  return job;
}

Future<Map<String, String>> getProfile(
    Web3Client ethereumClient, LocalStorage storage, String jobAddress) async {
  var alias = await queryFromStorage(
      ethereumClient, storage, 'GigMeProfile', 'profileAlias', []);
  var firstname = await queryFromStorage(
      ethereumClient, storage, 'GigMeProfile', 'firstname', []);
  var lastname = await queryFromStorage(
      ethereumClient, storage, 'GigMeProfile', 'lastname', []);
  var contactValue = await queryFromStorage(
      ethereumClient, storage, 'GigMeProfile', 'contactValue', []);

  Map<String, String> profile = {
    "title": alias[0].toString(),
    "description": firstname[0].toString(),
    "soliciter": lastname[0].toString(),
    "salary": contactValue[0].toString(),
    "address": jobAddress,
  };
  // print('Returning Profile');
  return profile;
}

Future<Map<String, String>> getJobFromMarket(
    Web3Client ethereumclient, LocalStorage storage, int index) async {
  var jobAddress = await query(
      ethereumclient,
      getContractAddressFromStorage(storage, 'GigMeJobMarketplace'),
      'GigMeJobMarketplace',
      'availableJobs',
      [BigInt.from(index)]);
  var job = await getJob(ethereumclient, jobAddress[0].toString());
  return job;
}

Future<void> createProfile(Web3Client ethereumClient, LocalStorage storage,
    String _alias, String _contactValue) async {
  var results = await transactionFromStorage(ethereumClient, storage,
      'GigMeCreateJobProfileUtil', 'createNewGigMeProfile', [
    _alias,
    _contactValue,
  ]);
  print(results);
}

Future<String> getProfileAlias(Web3Client ethereumClient, LocalStorage storage,
    String contractName, String functionName, List<dynamic> args) async {
  var results = await queryFromStorage(
      ethereumClient, storage, 'GigMeProfile', 'getAlias', []);
  return results[0].toString();
}

Future<void> updateAliasTest(Web3Client ethereumClient, LocalStorage storage,
    String contractName, String functionName, List<dynamic> args) async {
  var results = await transactionFromStorage(
      ethereumClient, storage, contractName, functionName, args);
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
