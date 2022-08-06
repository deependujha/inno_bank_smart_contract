// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Inno-Bank
 *  -> A non-profit organization for innovators and problem solvers
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

 struct Request{
    string name;
    uint8 age;
    string idea;
    uint funds;
}

contract InnoBank {

    mapping(address => uint256) public donated;
    mapping(address => uint256) public received;
    mapping(address=>uint) public requestsMade;
    mapping(address=>mapping(uint=>Request)) public Requests;


    // To check the balance of the smart-contract (Inno Bank)
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    

    // To donate money anonymously
    function donateAnonymously() public payable{
        donated[address(0)]+=msg.value;
    }


    // Donate money with your identity
    function donate() public payable{
        donated[msg.sender]+=msg.value;
    }

    // Make request with your identity
    function makeRequest(string memory name, uint8 age, string memory idea, uint funds)public returns(uint){
        uint count = requestsMade[msg.sender];
        count++;
        requestsMade[msg.sender]++;
        Requests[msg.sender][count]=Request(name,age,idea,funds);
        return count;
    }


    // Make request anonymously
    function makeRequestAnonymously(string memory idea, uint funds)public returns(uint){
        uint count = requestsMade[address(0)];
        count++;
        requestsMade[address(0)]++;
        Requests[address(0)][count]=Request('',0,idea,funds);
        return count;
    }
    
    

    
    
}