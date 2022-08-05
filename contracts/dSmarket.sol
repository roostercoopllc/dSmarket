// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract dSmarketPlace is Ownable {
  mapping(address => address payable) addToPayable; 

  event newJobPosting(address _jobPoster);
  event removeJobPosting(address _badJobAddress);

  dSmarketJob[] public availableJobs;

  function advertiseJob(dSmarketJob _jobAddress) public {
    availableJobs.push(_jobAddress);
    emit newJobPosting(msg.sender);
  }

  function totalAvailableJobs() public view returns (uint256){
      return availableJobs.length;
  }

  function removeBadJob(uint256 index) public onlyOwner {
      require (index <= availableJobs.length, "Job is not in the available jobs");
      if (index != availableJobs.length) {
          delete availableJobs[index];
          availableJobs[index] = availableJobs[availableJobs.length - 1];
      }
      availableJobs.pop();
  }
}

contract dSmarketCreateJob {
    mapping(address => ERC20) addToERC20;

    address public LinkToken = 0x70d1F773A9f81C852087B77F6Ae6d3032B02D2AB;
    address public MaticToken = 0x70F34801Fda881Fa89C410D3052816889A4adb21;

    function createNewJob(
        dSmarketPlace _marketAddress,
        string memory _title,
        string memory _description,
        uint256 _paymentToken,
        uint256 _paymentInWei
    ) public {
        /*
        if (_paymentToken == 0) {
            require( addToERC20[MaticToken].balanceOf(address(this)) > (_paymentInWei * 10**18), "Not enough MATIC to request this job");
        } else {
            require( addToERC20[LinkToken].balanceOf(address(this)) > (_paymentInWei * 10**18), "Not enough LINK to request this job");
        }
        */
        // dSmarketJob _job = new dSmarketJob(_title, _description, _paymentToken, _paymentInWei)
        _marketAddress.advertiseJob(new dSmarketJob(_title, _description, _paymentToken, _paymentInWei));
    } 
}

contract dSmarketJob is Ownable {
    using SafeMath for uint256;
    using Strings for string;

    //Mappings
    mapping(address => dSmarketJob) addressToJob;
    mapping(address => address payable) addToPayable;

    // Controlled Values
    enum JobStatus {
        OPEN,
        ACCEPTED,
        COMPLETED,
        WITHDRAWN
    }
    enum PaymentType {
        // ETH,
        MATIC,
        LINK
    }

    // Required Variables
    address payable public soliciter;
    string public title;
    string public description;
    // Internally Manipulated Values
    JobStatus public status;
    // Externally manipulated values
    PaymentType paymentToken;
    uint256 public paymentInWei;

    // Externally referenced values
    dSmarketCompletion public smarketCompletion;
    dSmarketCloseout public smarketCloseout;
    dSmarketRating public smarketRating;

    // Events
    event JobCreation(string jobCreationEvent);
    event RatingPosted(dSmarketRating ratingPosted, string rating);
    
    // The actual Work
    constructor(
        string memory _title,
        string memory _description,
        uint256 _paymentToken,
        uint256 _paymentInWei
    ) {
        soliciter = addToPayable[msg.sender];
        title = _title;
        description = _description;
        paymentToken = PaymentType(_paymentToken);
        paymentInWei = _paymentInWei;
        status = JobStatus.OPEN;
    }

    //Utility functions
    function getPaymentTypeAddress() public view returns (address) {
        if (paymentToken == PaymentType.LINK) {
            return 0x70d1F773A9f81C852087B77F6Ae6d3032B02D2AB;
        }
        // unless link specified return MATIC
        return 0x0000000000000000000000000000000000001010;
    }

    function setSmarketCompletion(dSmarketCompletion _smarketCompletion) public onlyOwner{
        smarketCompletion = _smarketCompletion;
    }
    function setSmarketCloseout(dSmarketCloseout _smarketCloseout) public onlyOwner {
        smarketCloseout = _smarketCloseout;
    }
    function addJobRating(string memory _ratingDescription, uint256 _rating) public onlyOwner {
        smarketRating = new dSmarketRating(addressToJob[address(this)], _ratingDescription, _rating);
        emit RatingPosted(smarketRating, _ratingDescription);
        status = JobStatus.COMPLETED;
    }
    function updateStatus(uint256 newStatusIndex) public onlyOwner {
        require (status != JobStatus.COMPLETED);
        if (JobStatus(newStatusIndex) == JobStatus.COMPLETED) {
            status = JobStatus(newStatusIndex);
        } else {
            status = JobStatus(newStatusIndex);
        }
    }
}

contract dSmarketCompletion {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;

    string public jobStatusDescription;
    address payable contractor;
    enum CompletionStatus {
        INPROGRESS,
        INCOMPLETE,
        COMPLETED
    }
    CompletionStatus public status;
    
    string[] public ipfsProofs;

    constructor(address payable _contractor, string memory jobStatusDesc) {
        require(status != CompletionStatus.COMPLETED, "Job already completed");
        contractor = _contractor;
        jobStatusDescription = jobStatusDesc;
    }
    function markJobAsComplete() public {
        status = CompletionStatus.COMPLETED;
    }
    function addJobPerformance(string memory _ipfsProof) public {
        ipfsProofs.push(_ipfsProof);
    }
}

contract dSmarketCloseout is Ownable {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;
    
    enum CompletionStatus {
        INPROGRESS,
        INCOMPLETE,
        COMPLETED
    }
    CompletionStatus public status;
    constructor() {
        status = CompletionStatus.INPROGRESS;
    }
    function setContractAsComplete() public onlyOwner {
        status = CompletionStatus.COMPLETED;
    }
    function setContractAsIncomplete() public onlyOwner {
        status = CompletionStatus.INCOMPLETE;
    }
}

contract dSmarketCheckout {
    event PaymentMessage(bytes data);

    mapping(address => uint256) paymentConversion;

    function completedContractAndPay(dSmarketJob _job, dSmarketCloseout _closeout, address payable _contractor) public {
        uint256 pay = _job.paymentInWei() * 10**18;
        (bool sent, bytes memory _data) = _contractor.call{value: pay, gas: 5000}("");
        emit PaymentMessage(_data);
        require(sent, "Failed to send token");
        _closeout.setContractAsComplete();
        _job.updateStatus(3);
    }
}

contract dSmarketRating is Ownable {
    using Strings for string;
    using SafeMath for uint256;
    using ECDSA for bytes32;
    

    dSmarketJob job;
    string ratingDescription;
    enum Rating {
        ABANDONED,
        INCOMPLETE,
        ACCEPTABLE,
        SATISFIED,
        EXCELLENT
    }
    Rating rating;

    constructor(dSmarketJob _dJob, string memory _ratingDescription, uint256 _rating) {
        job = _dJob;
        ratingDescription = _ratingDescription;
        rating = Rating(_rating);
    }
}

contract dSmarketNegotiation is Ownable {
  using ECDSA for bytes32;

  mapping(address => address payable) addToPay;

  event NegotiationAccepted(string acceptanceMessage);
  event newOfferSubmitted(dSmarketJob _job, address _sender);
  event newMessageAvailable(address _address, string _message);
  
  dSmarketJob jobAddress;
  address payable jobOwner;
  address payable contractor;
  struct Message {
    address sender;
    string description;
    uint256 startTime;
    uint256 paymentType;
    uint256 payment;
    uint256 duration;
  }
  Message[] public messages;
  enum NegotiationStatus {
    OPEN,
    CLOSED,
    FINAL
  }
  NegotiationStatus status;

  constructor(dSmarketJob _jobAddress, address payable _jobOwner) {
    jobAddress = _jobAddress;
    jobOwner = _jobOwner;
    contractor = addToPay[msg.sender];
    emit newOfferSubmitted(_jobAddress, msg.sender);
  }

  function isNegotiating(address _addressCheck) public view returns(bool){
    return (contractor == _addressCheck || jobOwner == _addressCheck);
  }

  function isNegotiationFinal() public view returns(bool){
    return status != NegotiationStatus.FINAL;
  }

  function negotiateJob(
    string memory _description,
    uint256 _startTime,
    uint256 _paymentType,
    uint256 _payment,
    uint256 _duration
    )
  public
  {
    // require (isNegotiating(msg.sender), "You are not part of this negotiation");
    require (isNegotiationFinal(), "The negotiation has closed and cannot be updated");
    messages.push(Message(
      msg.sender,
      _description,
      _startTime,
      _paymentType,
      _payment,
      _duration
    ));
    emit newMessageAvailable(msg.sender, _description);
  }

  function getLatestTerms() public view returns (Message memory) {
      return messages[messages.length - 1];
  }

  function acceptNegotiation() public onlyOwner{
    status = NegotiationStatus.FINAL;
  }

  function withdrawNegotiation() public {
      require(msg.sender == jobOwner, "You are not the contractor, and cannot withdraw contract");
    status = NegotiationStatus.CLOSED;
  }

  function acceptOffer() public{
        require(msg.sender == jobOwner);
        emit NegotiationAccepted("Negotiation has been accepted. Job commences now!");
        // Create Completion for contractor
        dSmarketCompletion completion = new dSmarketCompletion(jobOwner,  "Job is accepted, and started.");
        // Create Closeout for contractor
        dSmarketCloseout closeout = new dSmarketCloseout();
        // Set the values
        jobAddress.setSmarketCompletion(completion);
        jobAddress.setSmarketCloseout(closeout);
    } 
}

contract dSmarketNegotiationUtil {
    mapping(address => address payable) addToPay;

    event NegotiationStarted(dSmarketNegotiation _negotiation, string message); 

    function startNegotiation(dSmarketJob _job) public returns (dSmarketNegotiation) {
        dSmarketNegotiation negotiationAddress = new dSmarketNegotiation(_job, addToPay[msg.sender]);
        emit NegotiationStarted(negotiationAddress, "Negotiation Started");
        return negotiationAddress;
    }
}

contract dSmarketProfile is Ownable {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;

    string public profileAlias;
    string public firstname;
    string public lastname;
    string public contactValue;
    dSmarketJob[] jobHistory;

    constructor(string memory _alias, string memory _contactValue) {
        profileAlias = _alias;
        contactValue = _contactValue;
    }

    function updateProfileInfo(
        string memory _alias,
        string memory _firstname,
        string memory _lastname,
        string memory _contactValue
    ) public onlyOwner {
        profileAlias = _alias;
        firstname = _firstname;
        lastname = _lastname;
        contactValue = _contactValue;
    }

    function addJobHistory(dSmarketJob _jobAddress) public onlyOwner {
        jobHistory.push(_jobAddress);
    }
}