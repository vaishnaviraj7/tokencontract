pragma solidity  ^0.4.0 ;

contract XYZToken
{
    mapping(address => uint256) public amount;

    uint256 totalAmount;
    string tokenName;
    string tokenSymbol;
    uint256 decimal;
    address owner;
    uint256 value;

    constructor () public 
    {
        
        totalAmount = 10000 * 10**18;
        tokenName = "XYZToken";
        tokenSymbol = "XYZ";
        decimal = 18;
        owner = msg.sender;
    }

    function mint () public 
    {
        amount[owner] += totalAmount;
    }


    function distributeToken(address[] addresses, uint256 _value) public
    {
     for (uint i = 0; i < addresses.length; i++) {
         amount[owner] -= _value;
         amount[addresses[i]] += _value;
         transfer(addresses[i], _value);
     }
}

    function transfer(address receiver ,uint256 _value) public returns(bool)
    {
        require(_value <= amount[msg.sender]);
        amount[owner] -= _value;
        amount[receiver] += _value;
        return true;

    }

    function distribute (address[] addresses)public 
    {
        transfer (addresses[0], 5000);
        transfer (addresses[1], 1000);
        transfer (addresses[2], 3000);
        transfer (addresses[3], 900);
        transfer (addresses[4], 100);

    }
}


