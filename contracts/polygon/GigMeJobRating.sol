// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GigMeJobRating {
    using SafeMath for uint256;
  
    event Rating(address indexed user, uint256 indexed jobId, uint256 indexed rating);
    
    struct Job {
        uint256 id;
        uint256 rating;
    }
    
    struct User {
        uint256 id;
        uint256 rating;
    }
    
    mapping(address => Job) jobs;
    mapping(address => User) users;
    
    function rate(address user, uint256 jobId, uint256 rating) public onlyOwner {
        require(jobs[jobId].rating == 0);
        require(users[user].rating == 0);
        jobs[jobId].rating = rating;
        users[user].rating = rating;
        Rating(user, jobId, rating);
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