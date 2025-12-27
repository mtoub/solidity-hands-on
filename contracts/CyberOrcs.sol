// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "contracts/interfaces/ICyberOrcs.sol";
import "contracts/Ownable.sol";

contract CyberOrcs is ICyberOrcs, Ownable {

    string private NAME;
    string  private SYMBOL;
    uint256  public immutable MAX_SUPPLY;

    uint256 public _totalSupply;
    mapping(address => uint256) private balance;
    mapping(address => mapping(address => uint256)) private _allowance;

    constructor(string memory name_, string memory symbol_, uint256 maxSupply_) Ownable(msg.sender) {
        NAME = name_;
        SYMBOL = symbol_;
        MAX_SUPPLY = maxSupply_;
    }

    function name() public view returns(string memory){
        return NAME;
    }

    function symbol() public view returns(string memory){
        return SYMBOL;
    }

    function decimals() public pure returns(uint8){
        return 18;
    }

    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns(uint256){
        return balance[_owner];
    }

    function transfer(address to, uint256 amount) public returns (bool success) {
        require(to != address(0), "CyberOrcs: Zero Address");
        uint256 mybalance = balance[msg.sender];
        require(mybalance >= amount, "CyberOrcs: Low Balance");
        balance[msg.sender]-=amount;
        balance[to]+=amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function mint(address to, uint256 amount) public onlyOwner returns (bool sucess) {
        require(to!= address(0), "CyberOrcs: Zero Address");
        require(_totalSupply + amount <= MAX_SUPPLY, "CyberOrcs: Max Supply Reached");
        balance[to]+=amount;
        _totalSupply+=amount;
        emit Transfer(address(0), to, amount);
        return true;
    }

    function burn(uint256 amount) public returns (bool) {
        uint256 myBalance = balance[msg.sender];
        require(myBalance >= amount, "CyberOrcs: Low Balance");
        balance[msg.sender]-=amount;
        _totalSupply-=amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        require(_spender != address(0), "CyberOrcs: Zero Address"); 
        _allowance[msg.sender][_spender]=_value;
        emit  Approval(msg.sender, _spender, _value);
        success = true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        remaining = _allowance[_owner][_spender];
    }
    

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_to != address(0), "CyberOrcs: Zero Address");
        uint256  myBalance = balance[_from];
        require(myBalance >= _value, "CyberOrcs: Low Balance");
        uint256 myAllowance = _allowance[_from][msg.sender];
        require(myAllowance >= _value, "CyberOrcs: Low Allowance");
        balance[_from]-=_value;
        balance[_to]+=_value;
        _allowance[_from][msg.sender]-=_value;
        emit Transfer(_from, _to, _value);
        return true;     
    }
}   