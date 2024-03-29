  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.18;

  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";

  contract TAYASWAPTOKEN is ERC20, Ownable {
    
      // the max total supply is 10000 for TayaSwap Tokens
      uint256 public constant maxTotalSupply = 1000000 * 10**18;

      constructor() ERC20("TayaSwap Token", "TAYASWAP") {
        _mint(msg.sender, maxTotalSupply);
      }
      
      /**
        * @dev withdraws all ETH and tokens sent to the contract
        * Requirements: 
        * wallet connected must be owner's address
        */
      function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
      }

      // Function to receive Ether. msg.data must be empty
      receive() external payable {}

      // Fallback function is called when msg.data is not empty
      fallback() external payable {}
  }
