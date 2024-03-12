// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

error Distribute__NotEligibleToDistribute();
error Distribute__FailedTransaction(uint256 index);

contract Distribute {
    address[6] public contributors;
    uint256 public createTime;

    constructor(address[6] memory _contributors) payable {
        createTime = block.timestamp;
        contributors = _contributors;
    }

    function distribute() external {
        if (block.timestamp <= createTime + 2 weeks) revert Distribute__NotEligibleToDistribute();

        uint256 amount = address(this).balance / 6;
        for (uint256 i = 0; i < 6; i++) {
            // Using inline assembly to send Ether and handle failures
            address payable recipient = payable(contributors[i]);
            assembly {
                let success := call(gas(), recipient, amount, 0, 0, 0, 0)
                if iszero(success) { revert(0, 0) }
            }
        }
    }
}

// OLD CONTRACT
//--------------

/* 

pragma solidity 0.8.15;
contract Distribute {
address[6] public contributors;
uint256 public createTime;
constructor(address[6] memory _contributors) payable {
createTime = block.timestamp;
contributors = _contributors;
}
function distribute() external {
require(
block.timestamp > createTime + 2 weeks,
"cannot call distribute yet"
);
uint256 amount = address(this).balance / 6;
payable(contributors[0]).transfer(amount);
payable(contributors[1]).transfer(amount);
payable(contributors[2]).transfer(amount);
payable(contributors[3]).transfer(amount);
payable(contributors[4]).transfer(amount);
payable(contributors[5]).transfer(amount);
}
}

*/
