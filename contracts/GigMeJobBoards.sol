// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GigMeJobAdvertisement {
  event newJobPosting(address _jobPoster);
  address availableJob;
  address[] availableJobs;
  constructor() {
  }
  function advertiseJob(address _jobAddress) public {
    availableJobs.push(_jobAddress);
    emit newJobPosting(_jobAddress);
  }
}

contract GigMeJobNegotiation is Ownable {
  event newOfferSubmitted(address _job, address _sender);
  event newMessageAvailable(address _address, string _message);
  address jobAddress;
  address jobOwner;
  address contractor;
  struct Message {
    address sender;
    string description;
    uint256 startTime;
    uint256 salary;
    uint256 duration;
  }
  Message[] messages;
  enum NegotiationStatus {
    OPEN,
    CLOSED,
    FINAL
  }
  NegotiationStatus status;

  constructor(address _jobAddress, address _jobOwner, address _contractor) {
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
    uint256 _salary,
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
      _salary,
      _duration
    ));
    emit newMessageAvailable(msg.sender, _description);
  }

  function acceptNegotiation() public {
    status = NegotiationStatus.FINAL;
  }

  function withdrawNegotiation() public {
    status = NegotiationStatus.CLOSED;
  }
}
