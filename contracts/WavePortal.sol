// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint totalWaves;

    // Emits an event which can be handled client-side
    event NewWave(address indexed from, uint timestamp, string message);

    // Custom Data type that can be customized and holds data inside it
    struct Wave {
        address waver;
        string message;
        uint timestamp;
    }

    // Array of structs (declared above)
    Wave[] waves;

    // Function to used to initialize state contract variables
    constructor() payable {
        console.log("Yo yo, we have been re-constructed!");
    }

    // Function to register waves sent from client into the contract
    function wave(string memory _message) public {
        totalWaves += 1;
        console.log(" waved w/ the following message: ", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        emit NewWave(msg.sender, block.timestamp, _message);

        uint prizeAmount = 0.0001 ether;
        require(prizeAmount <= address(this).balance, "Trying to withdraw more ETH than what the contract has.");
        (bool success,) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw ETH from contract.");
    }

    // Function to return all waves sent to the contract
    function getAllWaves() view public returns (Wave[] memory) {
        return waves;
    }

    // Function to return the count of all waves sent to the contract
    function getTotalWaves() view public returns (uint) {
        return totalWaves;
    }
}
