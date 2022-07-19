
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract GigMeSignatures() {
  function verifySignature(string memory message, bytes memory signature) public pure returns(address) {
        bytes32 messageHash = getMessageHash(message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, signature);
    }
}