// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract GigMeJob is Ownable{
    using SafeMath for uint256;
    using Strings for string;

    event ContractorSelected(address _contractorAddress);
    event JobMarkedCompleted(address _jobCompletionAddress);

    enum JobStatus {
        OPEN,
        ACCEPTED,
        COMPLETED,
        WITHDRAWN
    }

    enum JobType {
        SERVICE,
        LABOR, 
        TRANSPORT,
        OTHER
    }
    
    // Initialize the job
    string public title;
    string public description;
    uint256 public startTime;
    JobStatus public status;
    uint256 salary;

    // Select and Actor for the job
    address public gigMeContractorAddress;
    address public gigMeContractorSignature;
    
    // Contractor fills out this information
    uint256 duration;
    uint256 endtime;
    GigMeJobCompletion public gigMeJobCompletion;
    address public gigMeJobCompletionSignature;
    
    // Owner sets final aspects of job and confirms funds released
    GigMeJobAcceptance public gigMeJobAcceptance;
    address public gigMeJobAcceptanceSignature;
    bool public fundsReleased;
    
    constructor(        
        string memory _title,
        string memory _description,
        uint256 _salary,
        uint256 _duration,
        uint256 _startTime)
    {
        title = _title;
        description = _description;
        salary = _salary;
        duration = _duration;
        startTime = _startTime;
        status = JobStatus.OPEN;
    }

    function canClose(address _contractor) public view returns(bool) {
        return gigMeContractorAddress == _contractor;
    }

    function acceptContractor(address _contractor) public onlyOwner {
        gigMeContractorAddress = _contractor;
        status = JobStatus.ACCEPTED;
        emit ContractorSelected(_contractor);
    }

    function completeContract(GigMeJobCompletion _gigMeJobCompletion)
    public
    {
        require(this.canClose(msg.sender), "The Sender is not the Contractor and cannot complete Job");
        gigMeJobCompletion = _gigMeJobCompletion;
        status = JobStatus.COMPLETED;
        emit JobMarkedCompleted(msg.sender);
        // start timer to release funds
    }
    
    function acceptContract(GigMeJobAcceptance _gigMeJobAcceptance) 
    public 
    onlyOwner 
    {
        gigMeJobAcceptance = _gigMeJobAcceptance;
        // release funds;
    }

    function recover(bytes32 ethSignedMessageHash, bytes memory signature) public pure returns(address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(signature);
        return ecrecover(ethSignedMessageHash, v, r, s);
    }
    function signMessage(bytes32 _message, address _signature) {
        if (gigMeContractorSignature == 0) {
            gigMeContractorSignature = _signature;
        } else if (gigMeJobCompletionSignature == 0) {
            gigMeJobCompletionSignature = _signature;
        } else if (gigMeJobAcceptanceSignature == 0) {
            gigMeJobAcceptanceSignature = _signature;
        } else {
            revert("Message already signed");
        }
    }
    function verifySignature(string memory message, bytes memory signature) public pure returns(address) {
        bytes32 messageHash = getMessageHash(message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, signature);
    }
}

contract GigMeJobAcceptance is Ownable {
    using SafeMath for uint256;
    using Strings for string;

    address public contractor;
    GigMeJobRating jobRating;
    uint256 expectedTime;

    enum CompletionStatus {
        INPROGRESS,
        INCOMPLETE,
        COMPLETED
    }

    CompletionStatus public status;

    constructor (address _contractor, uint256 _expectedTime) {
        contractor = _contractor;
        expectedTime = _expectedTime;
        status = CompletionStatus.INPROGRESS;
    }

    function markJobAsComplete() public {
        status = CompletionStatus.COMPLETED;
    }
}

contract GigMeJobCompletion {
    using SafeMath for uint256;
    using Strings for string;

    address public job;
    string public jobCompletionSummary;
    string[] public ipfsProofs;
    constructor (address _job, string memory _Summary) {
        job = _job;
        jobCompletionSummary = _Summary;
    }
    function addJobPerformance(string memory _ipfsProof) public {
        ipfsProofs.push(_ipfsProof);
    }
}

contract GigMeProfile is Ownable {
    using SafeMath for uint256;
    using Strings for string;

    string public profileAlias;
    string firstname;
    string lastname;
    enum ContactType {
        PHONE,
        EMAIL,
        IPFS,
        SOCIAL,
        OTHER
    }
    ContactType public contactType;
    string contactValue;
    GigMeJob[] jobHistory;
    constructor(
        address _contractorAddress,
        string memory _alias,
        string memory _contactValue) {
        contractorAddress = _contractorAddress;
        profileAlias = _alias;
        contactValue = _contactValue;
    }

    function addJobHistory(GigMeJob _jobAddress) public {
        jobHistory.push(_jobAddress);
    }
}

contract GigMeJobRating is Ownable{
    using Strings for string;
    using SafeMath for uint256;

  GigMeJob job;
  string ratingTitle;
  enum Rating {
    ABANDONED,
    INCOMPLETE,
    ACCEPTABLE,
    SATISFIED,
    EXCELLENT
  }
  Rating rating;

  constructor() {
    
  }
}

