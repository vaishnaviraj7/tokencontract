// SPDX-License-Identifier: MIT

pragma solidity  ^0.4.0 ;

contract stakeable 
{

    struct Staker 
    {
        uint256 deposited;
        uint256 timeOfLastUpdate;
        uint256 unclaimedRewards;
    }

    address [] stakeholders;
    uint256 stakingStartTime;
    uint256 totalStake; 
    uint256 rewardPerDay;
    uint256 _totalSupply;
    string _name;

    mapping(address => Staker) internal stakers;
    mapping(address => uint256) public balance;
    mapping(address => uint256) stakeAmount;


    constructor() public
    {
        stakingStartTime = block.timestamp;
        _name = "ABC";
        _totalSupply = 40000 * 10 ** 18;
    }
    

     function deposit(uint256 _amount) public
    {
        if (stakers[msg.sender].deposited == 0) 
        {
            stakers[msg.sender].deposited = _amount;
            stakers[msg.sender].timeOfLastUpdate = block.timestamp;
            stakers[msg.sender].unclaimedRewards = 0;
        } 
        else 
        {
            uint256 rewards = calculateRewards(msg.sender);
            stakers[msg.sender].unclaimedRewards += rewards;
            stakers[msg.sender].deposited += _amount;
            stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        }
    }


    function isStakeholder(address _address) public view returns(bool, uint256)
    {
        for (uint256 i = 0; i < stakeholders.length; i++)
        {
            if (_address == stakeholders[i]) 
            {
                return (true, i);
            }
        }
        return (false, 0);
    }


    function addStakeholder(address _stakeholder) public
    {
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        if(!_isStakeholder) stakeholders.push(_stakeholder);
    }


    function div(uint256 a, uint256 c) internal pure returns (uint256) 
    {
            require(c > 0);
            return a / c;
    }
    

    function CalculateTotalStake () public returns (uint256)
     {
        for (uint256 i = 0; i< stakeholders.length; i++)
        {
            totalStake += stakeAmount[stakeholders[i]];
        }
        return  totalStake;
    }


    function CalculaterewardPerDay () public returns (uint256)
    {
        for (uint256 i=0; i < stakeholders.length; i++) 
        {
            uint256 b = div (10000, 356);
            rewardPerDay  = (div (stakeAmount[stakeholders[i]], totalStake)) * b;
        }
        return rewardPerDay;
    }
    

     function calculateRewards(address _staker) public view returns (uint256 rewards)
    {
        uint256 time;
        time = block.timestamp - stakers[_staker].timeOfLastUpdate;
        rewards = ((time) * stakers[_staker].deposited) * rewardPerDay; 
        return rewards;
    }
    

    function mint (uint256 value) public
    {
        balance[msg.sender] += value;
    }
    

    function claimRewards() public
    {
        uint256 rewards = calculateRewards(msg.sender) + stakers[msg.sender].unclaimedRewards;
        require(rewards > 0);
        stakers[msg.sender].unclaimedRewards = 0;
        stakers[msg.sender].timeOfLastUpdate = block.timestamp;
        mint(rewards);
    }
        
}

