pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./dydx/DyDxFlashLoan.sol";
import "./IERC20.sol";


contract FlashloanTaker is DyDxFlashLoan {
    uint256 public loan;

    constructor() public payable {
        (bool success, ) = WETH.call.value(msg.value)("");
        require(success, "fail to get weth");
    }

    function getFlashloan(address flashToken, uint256 flashAmount) external {
        uint256 balanceBefore = IERC20(flashToken).balanceOf(address(this));
        bytes memory data = abi.encode(flashToken, flashAmount, balanceBefore);
        flashloan(flashToken, flashAmount, data); // execution goes to `callFunction`

        // and this point we have succefully paid the dept
    }

    function callFunction(
        address, /* sender */
        Info calldata, /* accountInfo */
        bytes calldata data
    ) external onlyPool {
        (address flashToken, uint256 flashAmount, uint256 balanceBefore) = abi
            .decode(data, (address, uint256, uint256));
        uint256 balanceAfter = IERC20(flashToken).balanceOf(address(this));
        require(
            balanceAfter - balanceBefore == flashAmount,
            "contract did not get the loan"
        );
        loan = balanceAfter;

        // do whatever you want with the money
        // the dept will be automatically withdrawn from this contract at the end of execution
    }
}
