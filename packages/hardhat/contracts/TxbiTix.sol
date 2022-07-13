pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract TxbiTix is ERC721URIStorage {
    // counter to keep track of the current token ID
    using Counters for Counters.Counter;
    Counters.Counter private currentId;

    // contract's state
    bool public saleIsActive = false;
    uint256 public totalTickets = 10;
    uint256 public availableTickets = 10;

    mapping(address => uint256[]) public holderTokenIDs;

    constructor() ERC721("TxbiTix", "TXBITix") {
        currentId.increment();
        console.log(currentId.current());
    }

    // Token mint funciton
    function mint() public {
        require(availableTickets > 0, "tickets outsold");
        _safeMint(msg.sender, currentId.current());
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
    function openSale() public {
        saleIsActive = true;
    }

    // disable availabilty of ticket sale
    function closeSale() public {
        saleIsActive = false;
    }
}
