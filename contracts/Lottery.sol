// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender; //we have access to this msg object anywhere in our contract fucntions, it's a global obj
    }

    //to  enter the lotery
    function enter() public payable {
        require(msg.value > .01 ether); //validate user is sending specified amount of ethereum
        players.push(msg.sender);
    }

    //generate random number using keccak algorithm
    function random() private view returns (uint256) {
        //block is another global object
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    }

    //to pick the winner of lottery
    function pickWinner() public restricted {
        uint256 index = random() % players.length; //using modulo to find random index of playets array
        //transfer ethereum
        payable(players[index]).transfer(address(this).balance); //this.balaance is the balance of contract
        players = new address[](0); //reset players to 0
    }

    //modifier function helps to avoid repetition of codes
    modifier restricted() {
        require(msg.sender == manager); // validate that only the manager can access this function
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}

//Class
