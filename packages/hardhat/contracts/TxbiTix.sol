pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract TxbiTix is ERC721URIStorage {
    bool public saleIsActive = false;

    constructor() ERC721("TxbiTix", "TXBITix") {}

    function openSale() public {
        saleIsActive = true;
    }

    function closeSale() public {
        saleIsActive = false;
    }
}
