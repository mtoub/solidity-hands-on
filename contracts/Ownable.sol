// SPDX-License-Identifier: MIT

pragma solidity >=0.8.24;

import "contracts/interfaces/IERC173.sol";

abstract contract Ownable is IERC173 {

    address public owner;

    constructor(address _initialOwner){
        _transferOwnership(_initialOwner);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: Caller is not the Owner");
        _;
    }

    function _transferOwnership(address _newOwner) internal {
        address oldOwner = owner;
        owner = _newOwner;
        emit OwnershipTransferred(oldOwner, _newOwner);
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Ownable: new owner is zero address");
        _transferOwnership(_newOwner);
    }

    function renounceOwnership() public onlyOwner {
        _transferOwnership(address(0));
    }
}