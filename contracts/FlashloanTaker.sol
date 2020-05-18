pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./dydx/DyDxFlashLoan.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlashloanTaker is DyDxFlashLoan {
    using SafeMath for uint;
    uint public loan;

    function getFlashloan(
        address flashToken,
        uint flashAmount
    ) external {
        uint balanceBefore = IERC20(flashToken).balanceOf(address(this));
        bytes memory data = abi.encode(flashToken, flashAmount, balanceBefore);
        flashloan(flashToken, flashAmount, data); // execution goes to `callFunction`

        // and this point we have succefully paid the dept
    }

    function callFunction(
        address /* sender */,
        Info calldata /* accountInfo */,
        bytes calldata data
    ) external onlyPool {
        (address flashToken, uint flashAmount, uint balanceBefore) = abi.decode(data, (address, uint, uint));
        uint balanceAfter = IERC20(flashToken).balanceOf(address(this));
        require(balanceAfter.sub(balanceBefore) == flashAmount, "contract did not get the loan");
        loan = balanceAfter;

        // do whatever you want with the money
        // the dept will be automatically withdrawn from this contract at the end of execution
    }
}