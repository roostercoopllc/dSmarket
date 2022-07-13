// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GigMeProfile is Ownable {
    // using SafeMath for uint256;

    event ProfileCreated(address indexed user);

    string profileAlias;
    string firstname;
    string lastname;
    enum ContactType {
        PHONE,
        EMAIL,
        IPFS,
        SOCIAL,
        OTHER
    }
    ContactType contactType;
    string contactValue;
    address[] jobHistory;

    mapping(uint256 => ContactType) contactTypeMap;

    constructor(string memory _alias, string memory _contactValue) {
        profileAlias = _alias;
        // contactType = _contactType;
        contactValue = _contactValue;
    }

    function addJobHistory(address _jobAddress) public {
        jobHistory.push(_jobAddress);
    }
}