// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GigMeNegotiation {
    using SafeMath for uint256;
    
    event Negotiation(address indexed user, uint256 indexed jobId, uint256 indexed price);
    
    struct Job {
        uint256 id;
        uint256 price;
        uint256 accepted;
    }
    
    struct User {
        uint256 id;
        uint256 accepted;
    }
    
    mapping(address => Job) jobs;
    mapping(address => User) users;
    
    function negotiate(address user, uint256 jobId, uint256 price) public onlyOwner {
        require(jobs[jobId].accepted == 0);
        require(users[user].accepted == 0);
        jobs[jobId].accepted = 1;
        users[user].accepted = 1;
        Negotiation(user, jobId, price);
    }
    
    function getJob(uint256 jobId) public view returns (Job) {
        return jobs[jobId];
    }
    
    function getUser(address user) public view returns (User) {
        return users[user];
    }
    
    function getJobs() public view returns (uint256[]) {
        uint256[] result;
        for (uint256 i = 0; i < jobs.length; i++) {
            result.push(i);
        }
        return result;
    }
    
    function getUsers() public view returns (address[]) {
        address[] result;
        for (address i = 0; i < users.length; i++) {
            result.push(i);
        }
        return result;
    }
}