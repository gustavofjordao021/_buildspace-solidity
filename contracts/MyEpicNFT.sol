// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

// Import OpenZeppelin ERC721 Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Import helper function to make Base64 files
import { Base64 } from "./libraries/Base64.sol";

// Inherit ERC721 methods
contract MyEpicNFT is ERC721URIStorage {
  // OpenZeppelin's method to counter the number of NFTs minted
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  
  // Base NFT style (black background with white, centered text)
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // Array with options to be used for randomization
  string[] characterMode = ["BaryonMode", "SageMode", "SixPathsMode", "LightningReleaseChakraMode", "SanninMode", "CurseMarkMode"];
  string[] characterName = ["Naruto", "Kakashi", "Sasuke", "Gaara", "Sakura", "Pain", "Tobi", "Madara", "Jiraya", "Orochimaru"];
  string[] characterJutsu = ["Rasengan", "Sharingan", "Rinnegan", "Susanoo", "Byakugan", "Chidori", "Kamui", "Izanagi"];

  // Function to emit event to frontend apps
  event NewEpicNFTMinted(address sender, uint256 tokenId);

  // Function to used to initialize state contract variables
  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("Check @2112.run for an amazing NFT project coming up :)");
  }

  // Function to randomly pick first word for the string
  function pickCharacterModeWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % characterMode.length;
    return characterMode[rand];
  }

  // Function to randomly pick second word for the string
  function pickCharacterNameWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % characterName.length;
    return characterName[rand];
  }

  // Function to randomly third second word for the string
  function pickCharacterJutsuWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % characterJutsu.length;
    return characterJutsu[rand];
  }

  // Standard function to defining random variable
  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  // Function to generate the NFT after picking randomized variables
  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    string memory first = pickCharacterModeWord(newItemId);
    string memory second = pickCharacterNameWord(newItemId);
    string memory third = pickCharacterJutsuWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A collection of ultimate Naruto Shippuden characters displaying their maximum powers and jutsus", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}