// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract dSmarketPlace is Ownable {
  using ECDSA for bytes32;

  mapping(address => address payable) addToPayable; 

  event newJobPosting(address _jobPoster);
  event removeJobPosting(address _badJobAddress);

  dSmarketJob[] public availableJobs;
  
  constructor() {}
  
  function createNewJob(
        string memory _title,
        string memory _description,
        // address payable _soliciter,
        uint256 _paymentToken,
        uint256 _paymentInWei,
        uint256 _duration,
        uint256 _startTime
    ) public returns (dSmarketJob retAddress) {
        dSmarketJob contractAddress = new dSmarketJob(_title, _description, addToPayable[msg.sender], _paymentToken, _paymentInWei, _duration, _startTime);
        availableJobs.push(contractAddress);
        return contractAddress;
    } 


  function advertiseExternalJob(dSmarketJob _jobAddress) public {
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

contract dSmarketJob is Ownable {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;

    //Mappings
    mapping(address => dSmarketJob) addressToJob;
    
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
    uint256 public startTime;
    uint256 public duration;
    uint256 public endtime;

    // Externally referenced values
    dSmarketProfile public contractor;
    dSmarketCompletion public smarketCompletion;
    dSmarketCloseout public smarketCloseout;
    dSmarketRating public smarketRating;

    dSmarketNegotiation.Message public agreedTerms;

    bool public fundsReleased;

    // Events
    event JobCreation(string jobCreationEvent);
    event NegotiationStarted(dSmarketNegotiation newNegotiation, string negotiationMessage);
    
    event RatingPosted(dSmarketRating ratingPosted, string rating);
    
    // The actual Work
    constructor(
        string memory _title,
        string memory _description,
        address payable _soliciter,
        uint256 _paymentToken,
        uint256 _paymentInWei,
        uint256 _duration,
        uint256 _startTime
    ) {
        soliciter = _soliciter;
        title = _title;
        description = _description;
        paymentToken = PaymentType(_paymentToken);
        paymentInWei = _paymentInWei;
        duration = _duration;
        startTime = _startTime;
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

    function startNegotiation() public returns (dSmarketNegotiation) {
        dSmarketNegotiation negotiationAddress = new dSmarketNegotiation(addressToJob[address(this)], soliciter, msg.sender);
        emit NegotiationStarted(negotiationAddress, "Negotiation Started");
        return negotiationAddress;
    }

    function addJobRating(string memory _ratingDescription, uint256 _rating) public onlyOwner {
        smarketRating = new dSmarketRating(addressToJob[address(this)], _ratingDescription, _rating);
        emit RatingPosted(smarketRating, _ratingDescription);
        status = JobStatus.COMPLETED;
    }

    function updateStatus(uint256 newStatusIndex) public onlyOwner {
        require (status != JobStatus.COMPLETED);
        status = JobStatus(newStatusIndex);
    }
}


contract dSmarketCompletion {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;

    string public jobStatusDescription;
    dSmarketProfile contractorProfile;
    enum CompletionStatus {
        INPROGRESS,
        INCOMPLETE,
        COMPLETED
    }
    CompletionStatus public status;
    string[] public ipfsProofs;

    constructor(dSmarketProfile _profile, string memory jobStatusDesc) {
        require(status != CompletionStatus.COMPLETED, "Job already completed");
        contractorProfile = _profile;
        jobStatusDescription = jobStatusDesc;
    }

    function markJobAsComplete() public {
        status = CompletionStatus.COMPLETED;
    }

    function addJobPerformance(string memory _ipfsProof) public {
        ipfsProofs.push(_ipfsProof);
    }

    function _verify(
        bytes32 data,
        bytes memory signature,
        address account
    ) internal pure returns (bool) {
        return data.toEthSignedMessageHash().recover(signature) == account;
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
    function markJobAsComplete() public onlyOwner {
        status = CompletionStatus.COMPLETED;
    }
    // recommended pay transaction as of dec2019
    /* function completeContractAndPay(address payable _to, address erc20Token) public payable {
        require(status != CompletionStatus.COMPLETED);
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
    */
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

  event NegotiationAccepted(string acceptanceMessage);
  event newOfferSubmitted(dSmarketJob _job, address _sender);
  event newMessageAvailable(address _address, string _message);
  
  dSmarketJob jobAddress;
  address jobOwner;
  address contractor;
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

  constructor(dSmarketJob _jobAddress, address _jobOwner, address _contractor) {
    jobAddress = _jobAddress;
    jobOwner = _jobOwner;
    contractor = _contractor;
    emit newOfferSubmitted(_jobAddress, msg.sender);
  }

  function isNegotiating(address _addressCheck) public view returns(bool){
    return (jobOwner == _addressCheck || contractor == _addressCheck);
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
    require (isNegotiating(msg.sender), "You are not part of this negotiation");
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
      require(msg.sender == contractor, "You are not the contractor, and cannot withdraw contract");
    status = NegotiationStatus.CLOSED;
  }

  function acceptOffer() public onlyOwner {
        emit NegotiationAccepted("Negotiation has been accepted. Job commences now!");
        // Set Values from Negotiation as new values
        // jobAddress.agreedTerms = getLatestTerms();
        // Create Completion for contractor
        // jobAddress.smarketCompletion = new dSmarketCompletion(contractor,  "Job is accepted, and started.");
        // Create Closeout for contractor
        // jobAddress.smarketCloseout = new dSmarketCloseout();
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