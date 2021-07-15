// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./StringUtils.sol";

contract PDS {
    mapping(string => string) public dataHash;
    mapping(address => bool) public wallets;
    mapping(address => bool) public admins;
    address private owner;
    uint256 public hashCount = 0;

    constructor(address[] memory accounts) {
        owner = msg.sender;
        for (uint256 i = 0; i < 2; i++) {
            admins[accounts[i]] = true;
        }
        for (uint256 i = 2; i < accounts.length; i++) {
            wallets[accounts[i]] = true;
        }
    }

    modifier onlyAuthorized {
        require(wallets[msg.sender], "You are not authorized");
        _;
    }

    modifier onlyOwner {
        require(owner == msg.sender, "You are not the contract owner");
        _;
    }

    function addUser(address addr) public onlyOwner {
        wallets[addr] = true;
    }

    function removeUser(address addr) public onlyOwner {
        wallets[addr] = false;
    }

    function addRecord(string calldata _id, string calldata hash)
        public
        onlyAuthorized
    {
        dataHash[_id] = hash;
        hashCount++;
    }

    function verifyRecord(string calldata hash, string calldata _id)
        public
        view
        returns (bool)
    {
        return StringUtils.equal(hash, dataHash[_id]);
    }
}
