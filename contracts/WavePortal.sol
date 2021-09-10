// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    // Declaration of state variables that are permanently stored in contract storage.
    uint totalWaves;
    uint private seed;

    // Emits an event which can be handled client-side
    event NewWave(address indexed from, uint timestamp, string message);

    // Declares a mapping to associate incoming messages to their sender's address
    mapping(address => uint) public lastWavedAt;

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

    // Function to register waves sent from client into the contract. It awards ETH to a random user based on dificulty set below
    function wave(string memory _message) public {
        // Ensures that messages can only be sent every 30 seconds by checking the current timestamp vs. the previously stored one
        require (lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Wait 30 seconds");

        // Updates the current wave timestamp stored
        lastWavedAt[msg.sender] = block.timestamp;
        
        totalWaves += 1;
        console.log(" waved w/ the following message: ", msg.sender, _message);

        // Creates a wave and adds it to array of structs called Waves. Then, emitss event for the client to pick up
        waves.push(Wave(msg.sender, _message, block.timestamp));
        emit NewWave(msg.sender, block.timestamp, _message);

        // Generate pseudrandom number based on block information in the range of 0 to 100
        uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        // Assign the generated random number as the seed for the next wave to improve security
        seed = randomNumber;

        // Gives a 15% chance that the user wins the prize
        if (randomNumber < 15) {
            console.log("%s won!", msg.sender);
            uint prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more ETH than what the contract has.");
            (bool success,) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw ETH from contract.");
        }        
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
