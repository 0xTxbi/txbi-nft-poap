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

    constructor() ERC721("TxbiTix", "TXBITix") {
        currentId.increment();
        console.log(currentId.current());
    }

    // Token mint function
    function mint() public payable {
        require(availableTickets > 0, "tickets outsold");
        require(msg.value >= mintPrice, "insufficient ETH");
        require(saleIsActive, "Tickets are currently unavailable");

        string[3] memory svg;
        svg[
            0
        ] = '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><text y="50">';
        svg[1] = Strings.toString(currentId.current());
        svg[2] = "</text></svg>";

        // Interpolate and encode svg image
        string memory image = string(abi.encodePacked(svg[0], svg[1], svg[2]));
        string memory encodedImage = Base64.encode(bytes(image));
        console.log(encodedImage);

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "TxbiTix #',
                        Strings.toString(currentId.current()),
                        '", "description": "A NFT-powered ticketing system", ',
                        '"traits": [{ "trait_type": "Checked In", "value": "true" }, { "trait_type": "Purchased", "value": "true" }], ',
                        '"image": "data:image/svg+xml;base64,',
                        encodedImage,
                        '" }'
                    )
                )
            )
        );

        string memory tokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log(tokenURI);

        console.log(tokenURI);

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
}
