// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract shiCoin {
    string private _name; //代币名称。
    string private _symbol; //代币符号。
    uint256 private _totalSupply; //代币总供应量。
    mapping(address => uint256) private _balances; //账户余额映射。
    mapping(address => mapping(address => uint256)) private _allowances; //授权额度映射。
    address public owner; //合约所有者

    event Transfer(address indexed from, address indexed target, uint256 amount);//转账事件。
    event Approval(address indexed owner, address indexed spender, uint256 amount);//授权事件。

    //在构造函数中初始化代币名称、符号和合约所有者。
    constructor(string memory name, string memory symbol, uint256 totalSupply,address _owner){
        _name = name;
        _symbol = symbol;
        _totalSupply = totalSupply;
        owner = _owner;
    }

    //使用onlyOwner修饰符限制某些函数只能由合约所有者调用。
    modifier onlyOwner {
        require(msg.sender == owner,"not owner");
        _;
    }

    modifier balanceEnough(address _owner, uint256 amount) {
        require(_balances[_owner] >= amount);
        _;
    }

    modifier allowancesEnough(address from,address target , uint256 amount) {
        require(_allowances[from][target] >= amount, "allowances not enough");
        _;
    }

    //返回代币名称
    function getName() public view returns(string memory) {
        return _name;
    }
    //返回代币符号
    function getSymbol() public view returns(string memory) {
        return _symbol;
    }
    //返回小数点位
    function decimals() public pure returns(uint256) {
        return 18;
    }
    //返回总供应量
    function getTotalSupply() public view returns(uint256) {
        return _totalSupply;
    }

    //查询账户余额
    function getMyBalance() public view returns(uint256) {
        return _balances[msg.sender];
    }

    //查询授权额度
    function getAllowances(address _owner,address target) public view returns(uint256) {
        return _allowances[_owner][target];
    }

    //实现设置授权额度的函数
    function setAllowances(address _owner, address target ,uint256 amount) public {
        _allowances[_owner][target] += amount;
        emit Approval(_owner, target, amount);
    }

    //实现从调用者地址向另一个地址转移代币的函数
    function tranfer(address target,uint256 amount) public balanceEnough(msg.sender,amount) {
        _balances[msg.sender] -= amount;
        _balances[target] += amount;
        emit Transfer(msg.sender, target, amount);
    }

    //实现从一个地址向另一个地址转移代币的函数（需要事先授权）
    function tranferFrom(address from, address target, uint256 amount) public allowancesEnough(from,target,amount) balanceEnough(from,amount) {
        _allowances[from][target] -= amount;
        _balances[from] -= amount;
        _balances[target] += amount;
        emit Transfer(from, target, amount);
    }

    //实现合约所有者可以增加代币供应量的函数。
    function increaseTotalSupply(address account, uint256 amount) public onlyOwner {
        _balances[account] += amount;
        _totalSupply += amount;
        emit Transfer(address(0), account, amount);
    }

    function burn(address account ,uint256 amount) public onlyOwner balanceEnough(account, amount) {
        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);

    }
}