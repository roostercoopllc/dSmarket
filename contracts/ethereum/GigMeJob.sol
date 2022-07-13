// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GigMeJobCatalogue is Ownable{
    event Acceptance(address indexed user, uint256 indexed jobId, uint256 indexed price);
    event JobCompleted(address indexed user, uint256 indexed jobId, uint256 indexed price);

    enum JobStatus {
        OPEN,
        ACCEPTED,
        COMPLETED,
        WITHDRAWN
    }

    address gigMeJobAcceptance;
    address gigMeProfile;

    string title;
    string description;
    uint256 salary;
    uint256 duration;
    uint256 startTime;
    uint256 endTime;
    JobStatus status;
    
    mapping(address => Job) jobMap;

    constructor(){

    }
    function AdvertiseJob(
        string memory _title,
        string memory _description,
        address _GigMeJobAcceptance,
        uint256 _salary,
        uint256 _duration,
        uint256 _startTime,
        uint256 _endtime,
        uint256 _expectedTime
    ) public onlyOwner {
            title = _title;
            description = _description;
            salary = _salary;
            duration = _duration;
            startTime = _startTime;
            endtime = _endtime;
            status = JobStatus.OPEN;
            gigMeJobAcceptance = _GigMeJobAcceptance;
    }
}

contract GigMeJobAcceptance {
    address public runner;
    uint256 expectedTime;

    enum CompletionStatus {
        INPROGRESS,
        DELAYED,
        COMPLETED
    }

    CompletionStatus public status;

    constructor (address _runner, uint256 _expectedTime) {
        runner = _runner;
        expectedTime = _expectedTime;
        status = CompletionStatus.INPROGRESS;
    }

}