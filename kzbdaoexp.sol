// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract KzbDaoExperiment is ERC20 {
    // The address of the NFT contract that grants access to minting
    address public nftContract;

    // The initial amount of tokens minted per call
    uint256 public initialMintAmount;

    // The daily decrease of the mint amount
    uint256 public dailyDecrease;

    // The timestamp of the contract deployment
    uint256 public startTime;

    constructor(address _nftContract) ERC20("KzbDaoExperiment", "KDE") {
        nftContract = _nftContract;
        initialMintAmount = 100 * 10 ** decimals();
        dailyDecrease = 1 * 10 ** decimals();
        startTime = block.timestamp;
    }

    function mint() external {
        // Check if the caller owns at least one NFT from the specified contract
        require(
            IERC721(nftContract).balanceOf(msg.sender) > 0,
            "You must own an NFT to mint tokens"
        );

        // Calculate how many days have passed since the start time
        uint256 _days = (block.timestamp - startTime) / 1 days;

        // Calculate the mint amount for the current day based on the initial amount and the daily decrease
        uint256 mintAmount = initialMintAmount - (_days * dailyDecrease);

        // Check if the mint amount is positive
        require(mintAmount > 0, "The minting period has ended");

        // Mint tokens to the caller according to the mint amount
        _mint(msg.sender, mintAmount);
    }
}
