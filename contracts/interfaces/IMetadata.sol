 // SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IMetadata {
    function name() view external returns (string memory);
    function symbol() view external returns (string memory);
    function baseTokenURI() view external  returns (string memory);
}