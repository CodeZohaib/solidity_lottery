// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Lottery {
    address payable[] public players;
    address public manager;
    
    constructor() {
        manager = payable(msg.sender);
    }
    
    receive() external payable {
        require(msg.value == 1 ether, "The value must be 1 ether.");
        players.push(payable(msg.sender));
    }
    
    function getBalance() public view returns(uint) {
        require(msg.sender == manager, "You are not the manager.");
        return address(this).balance;
    }
    
    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.basefee, block.timestamp, players.length)));
    }
    
    function pickWinner() public {
        require(msg.sender == manager, "Only the manager can pick a winner.");
        require(players.length >= 3, "There must be at least 3 players to pick a winner.");
        uint r = random();
        address payable winner;
        uint index = r % players.length;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0);
    }
}