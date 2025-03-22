pragma solidity ^0.8.11;

contract UpgradedContract {
    uint256 public number;

    function setNumber(uint256 _number) public {
        number = _number;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }

    function addNumber(uint256 _value) public {
        number += _value;
    }
}
