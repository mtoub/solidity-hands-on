// SPDX-License-Identifier: MIT

pragma solidity >=0.8.24;

import "contracts/interfaces/IOrcsNFT.sol";
import {IERC721Receiver} from "contracts/interfaces/IERC721Receiver.sol";
import "contracts/Ownable.sol";
import "contracts/interfaces/IMetadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract OrcsNFT is IOrcsNFT, Ownable {

    using Strings for uint256;

    uint256 public immutable MAX_TOKEN;

    string public name;  // function name() view public returns (string memory);
    string public symbol;  // function symbol() view public returns (string memory);
    string public baseTokenURI;  // function baseTokenURI() view public returns (string memory);

    mapping(address => uint256) private _balances; 
    mapping(uint256 => address) private _owners;
    mapping(uint256 => address) private _operators;
    mapping(address => mapping(address => bool)) private _approvedForAll;


    constructor(string memory _name, string memory _symbol, string memory _baseTokenURI, uint256 _maxToken, address _initialOwner) Ownable(_initialOwner) {
        name = _name;
        symbol = _symbol;
        baseTokenURI =_baseTokenURI;
        MAX_TOKEN = _maxToken;
    } 


    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        address owner = _owners[_tokenId];
        require(owner != address(0), "OrcsNFT: NFT doesn't exist");
        return string.concat(
            baseTokenURI,
            Strings.toString(_tokenId)
        );
    }

    function mint(address _to, uint256 _tokenId) public onlyOwner {
        require(_tokenId <= MAX_TOKEN, "OrcsNFT: NFT doesn't exist");
        require(_to != address(0), "OrcsNFT: minting to zero address");
        require(_owners[_tokenId] == address(0), "OrcsNFT: Token already exist");
        _balances[_to] += 1; 
        _owners[_tokenId] = _to;
        emit Transfer(address(0), _to, _tokenId);  
    }

    function burn(uint256 _tokenId) public {
        address owner = _owners[_tokenId];
        require(owner == msg.sender, "OrcsNFT: caller is not owner");
        _balances[msg.sender]-=1;
        delete _owners[_tokenId];
        approve(address(0),_tokenId);
        emit Transfer(owner, address(0), _tokenId);
    }

    function balanceOf(address _owner) public view returns (uint256){
        return _balances[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address owner){
        owner = _owners[_tokenId];
        require(owner != address(0), "OrcsNFT: Token does not exist");
    }

    function getApproved(uint256 _tokenId) public view returns (address){
        return _operators[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view returns (bool){
        return _approvedForAll[_owner][_operator];
    }

    function approve(address _approved, uint256 _tokenId) public payable {
        address _owner = ownerOf(_tokenId);
        require(_owner == msg.sender || isApprovedForAll(_owner, msg.sender), 
            "OrcsNFT: Not authorized");
        _operators[_tokenId]=_approved;
        emit Approval(_owner, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) public {
        _approvedForAll[msg.sender][_operator]=_approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        address _owner = ownerOf(_tokenId);
        require(_from == _owner, "OrcsNFT: From not Owner");
        address _approved = getApproved(_tokenId);
        require(msg.sender == _from || msg.sender == _approved || isApprovedForAll(_owner, msg.sender),
            "OrcsNFT: From not authorized");
        _balances[_from]-=1;
        _balances[_to]+=1;
        _owners[_tokenId]=_to;
        _operators[_tokenId]=address(0);
    }


    function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
        _transferFrom(_from,_to, _tokenId);
        emit Transfer(_from, _to, _tokenId); 
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public payable {
        _transferFrom(_from,_to, _tokenId);

        if(_to.code.length > 0) {
            IERC721Receiver nftReceiver = IERC721Receiver(_to);
            bytes4 response = nftReceiver.onERC721Received(msg.sender, _from, _tokenId, _data);
            require(response == IERC721Receiver.onERC721Received.selector, "OrcsNFT: Transfer Not Safe");
        }

        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable {
        safeTransferFrom(_from, _to, _tokenId, "");
    }
}