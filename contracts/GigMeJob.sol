// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";

contract GigMeJob is Ownable {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;

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
    address public soliciter; // The address of the person who created the job
    string public title;
    string public description;
    uint256 public startTime;
    JobStatus public status;
    uint256 salary;

    // Contractor fills out this information
    uint256 duration;
    uint256 endtime;
    GigMeJobCompletion public gigMeJobCompletion;

    // Owner sets final aspects of job and confirms funds released
    GigMeJobCloseout public gigMeJobCloseout;
    bool public fundsReleased;

    constructor(
        string memory _title,
        string memory _description,
        address _soliciter,
        uint256 _salary,
        uint256 _duration,
        uint256 _startTime
    ) {
        soliciter = _soliciter;
        title = _title;
        description = _description;
        salary = _salary;
        duration = _duration;
        startTime = _startTime;
        status = JobStatus.OPEN;
    }

    function canClose(address _contractor) public view returns (bool) {
        return gigMeContractorAddress == _contractor;
    }

    function acceptContractor(address _contractor) public onlyOwner {
        gigMeContractorAddress = _contractor;
        status = JobStatus.ACCEPTED;
        emit ContractorSelected(_contractor);
    }

    function completeContract(GigMeJobCompletion _gigMeJobCompletion) public {
        require(
            this.canClose(msg.sender),
            "The Sender is not the Contractor and cannot complete Job"
        );
        gigMeJobCompletion = _gigMeJobCompletion;
        status = JobStatus.COMPLETED;
        emit JobMarkedCompleted(msg.sender);
        // start timer to release funds
    }

    function acceptContract(address _gigMeJobCloseout)
        public
        onlyOwner
    {
        gigMeJobCloseout = _gigMeJobCloseout;
        
    }
}

contract GigMeJobCloseout is Ownable {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;

    address public contractor;
    GigMeJobRating jobRating;
    uint256 expectedTime;

    enum CompletionStatus {
        INPROGRESS,
        INCOMPLETE,
        COMPLETED
    }

    CompletionStatus public status;

    constructor(address _contractor, uint256 _expectedTime) {
        contractor = _contractor;
        expectedTime = _expectedTime;
        status = CompletionStatus.INPROGRESS;
    }

    function markJobAsComplete() public onlyOwner {
        status = CompletionStatus.COMPLETED;
    }

    function changeExpectedTime(uint256 _expectedTime) public onlyOwner {
        expectedTime = _expectedTime;
    }
    
    function _verify(
        bytes32 data,
        bytes memory signature,
        address account
    ) internal pure returns (bool) {
        return data.toEthSignedMessageHash().recover(signature) == account;
    }
}

contract GigMeJobCompletion {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;

    address public job;
    string public jobCompletionSummary;
    enum CompletionStatus {
        INPROGRESS,
        INCOMPLETE,
        COMPLETED
    }
    CompletionStatus public status;
    string[] public ipfsProofs;

    constructor(address _job, string memory _Summary) {
        require(status != CompletionStatus.COMPLETED, "Job already completed");
        job = _job;
        jobCompletionSummary = _Summary;
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

contract GigMeProfile is Ownable {
    using SafeMath for uint256;
    using Strings for string;
    using ECDSA for bytes32;

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

    constructor(string memory _alias, string memory _contactValue) {
        profileAlias = _alias;
        contactValue = _contactValue;
    }

    function addJobHistory(GigMeJob _jobAddress) public {
        jobHistory.push(_jobAddress);
    }

    function _verify(
        bytes32 data,
        bytes memory signature,
        address account
    ) internal pure returns (bool) {
        return data.toEthSignedMessageHash().recover(signature) == account;
    }
}

contract GigMeJobRating is Ownable {
    using Strings for string;
    using SafeMath for uint256;
    using ECDSA for bytes32;
    

    address job;
    string ratingTitle;
    enum Rating {
        ABANDONED,
        INCOMPLETE,
        ACCEPTABLE,
        SATISFIED,
        EXCELLENT
    }
    Rating rating;

    constructor(address _gigMeJob) {
        job = _gigMeJob;
    }

    function _verify(
        bytes32 data,
        bytes memory signature,
        address account
    ) onlyOwner internal pure returns (bool) {
        return data.toEthSignedMessageHash().recover(signature) == account;
    }
}
