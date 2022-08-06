// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Inno-Bank
 *  -> A non-profit organization for innovators and problem solvers
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */

 struct Request{
    address requestedBy;
    string name;
    uint8 age;
    string idea;
    uint funds;
    bool approved;
    uint support;
}

contract InnoBank {

    uint totalVoters;
    uint reqId;
    mapping(address => bool) public voter;
    mapping(address => uint256) public donated;
    mapping(address => uint256) public received;
    mapping(uint256 => Request) private requestDetail;
    mapping(address=>mapping(uint=>Request)) private requests;
    mapping(address=>mapping(uint=>bool)) private voted;


    // To check the balance of the smart-contract (Inno Bank)
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // become a voter in the bank
    function becomeAVoter() public payable{
        require(msg.value>=5 ether,"You need to deposit at least 5 ethers to become a voter.");
        totalVoters++;
        voter[msg.sender]=true;
    }
    
    // To donate money anonymously
    function donateAnonymously() public payable{
        donated[address(0)]+=msg.value;
    }

    // Donate money with your identity
    function donate() public payable{
        donated[msg.sender]+=msg.value;
    }

    // make a request. The limit to ask for fund is upto 50 ethers.
    function makeRequest(string memory name, uint8 age, string memory idea, uint funds)public returns(uint){
        if(funds>50000000000000000000){funds=50000000000000000000;}
        reqId++;
        requests[msg.sender][reqId]=Request(msg.sender,name,age,idea,funds,false,0);
        requestDetail[reqId]=Request(msg.sender,name,age,idea,funds,false,0);
        return reqId;
    }

    // make a request anonymously. The limit to ask for fund is upto 50 ethers.
    function makeRequestAnonymously(string memory idea, uint funds)public returns(uint){
        if(funds>50000000000000000000){funds=50000000000000000000;}
        reqId++;
        requests[address(0)][reqId]=Request(msg.sender,'',0,idea,funds,false,0);
        requestDetail[reqId]=Request(msg.sender,'',0,idea,funds,false,0);
        return reqId;
    }

    function transferMoney(uint _reqId)public payable{
        require(requestDetail[_reqId].support >= totalVoters/2,"This request doesn't have support of 50% or more voters.");
        require(requestDetail[_reqId].funds <=address(this).balance,"We don't have sufficient balance right now.");
        payable(requestDetail[_reqId].requestedBy).transfer(requestDetail[_reqId].funds);
        delete requestDetail[_reqId];
    }
    
    function voteForARequest(uint _reqId)public{
        require(requestDetail[_reqId].funds!=0,"No request exists with this request Id.");
        require(voter[msg.sender]==true,"You are not a voter.");
        require(voted[msg.sender][_reqId]==false,"You have already voted.");
        voted[msg.sender][_reqId]=true;
        requestDetail[_reqId].support++;
        if(requestDetail[_reqId].support >  totalVoters/2 ){
            transferMoney(_reqId);
        }
    }

    function getRequestDetails(uint _reqId)public view returns(Request memory){
        Request memory data = requestDetail[_reqId];
        if(data.age==0){
            data.requestedBy=address(0);
        }
        return data;
    }

    
    
}