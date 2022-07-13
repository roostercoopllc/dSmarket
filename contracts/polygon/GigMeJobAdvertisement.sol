// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GigMeJobAdvertisement {
  address GigMeJob;
  address[] jobs;
  
  event AdvertiseNewJob(
    address indexed caller,
    string indexed title,
    string indexed description,
    uint256 salary,
    uint256 duration,
    uint256 startTime,
    uint256 endTime
  );

  constructor(){
  }

  function advertiseNewJob(
    string memory _title,
    string memory _description,
    address _GigMeJobAcceptance,
    uint256 _salary,
    uint256 _duration,
    uint256 _startTime,
    uint256 _endtime
    ) public {
      jobs.push(
        _GigMeJobAcceptance
      );
      emit AdvertiseNewJob(msg.sender, _title, _description, _salary, _duration, _startTime, _endtime);
  }

}