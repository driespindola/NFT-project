
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base {fill: #c24a54; font-family: sans-serif; font-size: 24px; } </style> <rect width='100%' height='100%' fill='#959fff' /> <text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

string[] firstWords = ["Foot", "Exempt", "Precision", "Store", "Resist", "Corner", "Trunk", "Sink", "Garlic", "Tune", "Emphasis", "Constitution", "Sermon", "Call", "Steel"];
string[] secondWords = ["Hortense", "Shprintzel", "Alf", "Linnea", "Nitza", "Whetu", "Ana", "Gerontius", "Bibek", "Ki", "Laokoon", "Ebbe", "Tatsuya", "Divina", "Azamat"];
string[] thirdWords = ["Fresh", "Tacky", "Thick", "Worried", "Shocking", "Simple", "Shrill", "Unwieldy", "Weak", "Even", "Squealing", "Cuddly", "Pricey", "Actual", "Rapid"];

constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract. Woah!");
}

function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
     uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
     rand = rand % firstWords.length;
     return firstWords[rand];
}

function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();
     string memory first = pickRandomFirstWord(newItemId);
     string memory second = pickRandomSecondWord(newItemId);
     string memory third = pickRandomThirdWord(newItemId);

     string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

     string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);

     _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
  }
}
