pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TxbiTix is ERC721URIStorage, Ownable {
    // counter to keep track of the current token ID
    using Counters for Counters.Counter;
    Counters.Counter private currentId;

    // contract's state
    bool public saleIsActive = false;
    uint256 public totalTickets = 10;
    uint256 public availableTickets = 10;
    // mint price
    uint256 public mintPrice = 50000000000000000;

    mapping(address => uint256[]) public holderTokenIDs;
    mapping(address => bool) public checkIns;

    constructor() ERC721("TxbiTix", "TXBITix") {
        currentId.increment();
    }

    function checkIn(address walletAddress) public {
        checkIns[walletAddress] = true;
        uint256 tokenID = holderTokenIDs[walletAddress][0];

        // NFT metadata
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "TxbiTix #',
                        Strings.toString(tokenID),
                        '", "description": "A NFT-powered ticketing system", ',
                        '"traits": [{ "trait_type": "Checked In", "value": "true" }, { "trait_type": "Purchased", "value": "true" }], ',
                        '"image": ipfs://QmXxGxBdZuPDS4DMiXZLeuxygaWP7DKZzfw8zN8XW7DB8p" }'
                    )
                )
            )
        );

        string memory tokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _setTokenURI(currentId.current(), tokenURI);
    }

    // Token mint function
    function mint() public payable {
        require(availableTickets > 0, "tickets outsold");
        require(msg.value >= mintPrice, "insufficient ETH");
        require(saleIsActive, "Tickets are currently unavailable");

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "TxbiTix #',
                        Strings.toString(currentId.current()),
                        '", "description": "A NFT-powered ticketing system", ',
                        '"traits": [{ "trait_type": "Checked In", "value": "false" }, { "trait_type": "Purchased", "value": "true" }], ',
                        '"image": ipfs://QmPQ3wrbA8U93C4Ho1wEa6rvytQoBrVM7hVv4Abcdvddaz" }'
                    )
                )
            )
        );

        string memory tokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, currentId.current());
        _setTokenURI(currentId.current(), tokenURI);

        currentId.increment();
        availableTickets = availableTickets - 1;
    }

    // return number of available tickets
    function availableTicketCount() public view returns (uint256) {
        return availableTickets;
    }

    // return total number of tickets
    function totalTicketCount() public view returns (uint256) {
        return totalTickets;
    }

    // enable availabilty of ticket sale
    function openSale() public onlyOwner {
        saleIsActive = true;
    }

    // disable availabilty of ticket sale
    function closeSale() public onlyOwner {
        saleIsActive = false;
    }

    // confirm ticket ownership
    function confirmOwnership(address walletAddress)
        public
        view
        returns (bool)
    {
        return holderTokenIDs[walletAddress].length > 0;
    }
}
