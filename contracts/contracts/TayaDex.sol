 // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.18;
  import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
  import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
  import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
  import "@openzeppelin/contracts/access/Ownable.sol";
  import "@openzeppelin/contracts/utils/math/SafeMath.sol";
  import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

  contract TayaSwap is ERC20 , Ownable  , ReentrancyGuard {

    using SafeMath for uint256 ; 

    IERC20 public  tayaToken;
      
    /**
     * 
     * @param _tayaSWAPtokenAddress The address of the TayaSwap token
     * @notice Taking tayaswap token address and then setting it up
     */  
    constructor(address _tayaSWAPtokenAddress) ERC20("Taya LP Token", "lpTAYA") {
          require(_tayaSWAPtokenAddress != address(0), "Token address passed is a null address");
          tayaToken = IERC20(_tayaSWAPtokenAddress);
      }
        
      /**
        *  @dev Adds liquidity to the exchange.
        */
    function addLiquidity(uint _amount) external  payable nonReentrant returns (uint) {

        require(_amount > 0, "Amount should be greater than zero");


        uint256  liquidity;
        uint256 ethReserve = address(this).balance;
        uint256 tayaTokenReserve = getTAYAReservebalance();
      
    /*
        If the reserve is empty, intake any user supplied value for
        `Ether` and `Crypto Dev` tokens because there is no ratio currently
    */
        if(tayaTokenReserve == 0) {
        tayaToken.transferFrom(msg.sender, address(this), _amount);
        liquidity = ethReserve;
        _mint(msg.sender, liquidity);
    } else {
      
        uint currentethReserve =  ethReserve - msg.value;
        uint tayaswaptokenamount = (msg.value * tayaTokenReserve)/(currentethReserve);
        require(_amount >= tayaswaptokenamount, "Amount of tokens sent is less than the minimum tokens required");
       
        tayaToken.transferFrom(msg.sender, address(this), tayaswaptokenamount);
    
        liquidity = (totalSupply() * msg.value)/ currentethReserve;
        _mint(msg.sender, liquidity);
    }
     return liquidity;
}


/** 
  * @dev remove the liquidity from the exchange
  */
  function removeLiquidity(uint _amount) external nonReentrant returns (uint , uint) {
      require(_amount > 0, "_amount should be greater than zero");
      uint ethReserve = address(this).balance;
      uint _totalSupply = totalSupply();
      uint ethAmount = (ethReserve * _amount)/ _totalSupply;
      // The amount of Crypto Dev token that would be sent back to the user is based
      // on a ratio
      // Ratio is -> (Crypto Dev sent back to the user) / (current Crypto Dev token reserve)
      // = (amount of LP tokens that user wants to withdraw) / (total supply of LP tokens)
      // Then by some maths -> (Crypto Dev sent back to the user)
      // = (current Crypto Dev token reserve * amount of LP tokens that user wants to withdraw) / (total supply of LP tokens)
      uint tayaswaptokenamount = (getTAYAReservebalance() * _amount)/ _totalSupply;
      require(ethAmount > 0 && tayaswaptokenamount > 0, "Invalid amount");
      // Burn the sent LP tokens from the user's wallet because they are already sent to
      // remove liquidity
      _burn(msg.sender, _amount);
      // Transfer `ethAmount` of Eth from user's wallet to the contract
      payable(msg.sender).transfer(ethAmount);
      // Transfer `cryptoDevTokenAmount` of Crypto Dev tokens from the user's wallet to the contract
      tayaToken.transfer(msg.sender, tayaswaptokenamount);
      return (ethAmount, tayaswaptokenamount);
  }


    /**
* @dev Returns the amount Eth/TayaSwap tokens that would be returned to the user
* in the swap
*/
function getAmountOfTokens(
    uint256 inputAmount,
    uint256 inputReserve,
    uint256 outputReserve
) public pure returns (uint256) {
    require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
    // We are charging a fee of `1%`
    // Input amount with fee = (input amount - (1*(input amount)/100)) = ((input amount)*99)/100
    uint256 inputAmountWithFee = inputAmount.mul(99).div(100);
    // Because we need to follow the concept of `XY = K` curve
    // We need to make sure (x + Δx) * (y - Δy) = x * y
    // So the final formula is Δy = (y * Δx) / (x + Δx)
    // Δy in our case is `tokens to be received`
    // Δx = ((input amount)*99)/100, x = inputReserve, y = outputReserve
    // So by putting the values in the formulae you can get the numerator and denominator
    uint256 numerator = inputAmountWithFee.mul(outputReserve);
    uint256 denominator = inputReserve.mul(100).add(inputAmountWithFee);
    return numerator.div(denominator);
}


/** 
* @dev Swaps Eth for TayaSwap  Tokens
*/
function ethToTayaToken(uint _minTokens , uint256 _slippage) public payable {
    uint256 tokenReserve = getTAYAReservebalance();
    uint256 ethReserve =  address(this).balance.sub(msg.value);
    // user has sent in the given call
    // so we need to subtract it to get the actual input reserve
    uint256 tokensBought = getAmountOfTokens(
        msg.value,
        ethReserve,
        tokenReserve
    );

    require(tokensBought >= _minTokens, "insufficient output amount");
    require(tokensBought.mul(100).div(msg.value) >= _slippage, "Slippage limit exceeded");
    // Transfer the `Crypto Dev` tokens to the user
    tayaToken.transfer(msg.sender, tokensBought);
}

/** 
* @dev Swaps TayaSwap  Tokens for Eth
*/
function tayaSwapTokenToEth(uint _tokensSold, uint _minEth , uint256 _slippage) public {
    uint256 tokenReserve = getTAYAReservebalance();
    uint256 ethReserve = address(this).balance;
    // call the `getAmountOfTokens` to get the amount of Eth
    // that would be returned to the user after the swap
    uint256 ethBought = getAmountOfTokens(
        _tokensSold,
        tokenReserve,
        ethReserve
    );
    
    // Calculate the slippage percentage
    uint256 slippagePercentage = ethBought.mul(100).div(_minEth);
    require(slippagePercentage >= _slippage, "Slippage limit exceeded");


    require(ethBought >= _minEth, "insufficient output amount");
    // Transfer `Crypto Dev` tokens from the user's address to the contract
    tayaToken.transferFrom(
        msg.sender,
        address(this),
        _tokensSold
    );
    // send the `ethBought` to the user from the contract
    payable(msg.sender).transfer(ethBought);
}


    /**
     * @notice Returns the ETH balance of this contract
     */
      function getETHReservebalance() public view returns(uint256) {
          return address(this).balance;
      }
      
    /**
     * @notice Returns the TAYA balance of this contract
     */
      function getTAYAReservebalance() public view returns(uint256) {
          return tayaToken.balanceOf(address(this));
      }
  }