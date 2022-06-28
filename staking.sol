// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract Staking
{
    address[] internal stakeholders;
    uint256 rewardPerDay;

    mapping(address => uint256) internal stakes;
    mapping(address => uint256) internal rewards;

    
    constructor(address _owner, uint256 _supply) public
    { 
        _mint(_owner, _supply);
    }


    function createStake(uint256 _stake) public
    {
        _burn(msg.sender, _stake);
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender] = stakes[msg.sender].add(_stake);
    }


    function removeStake(uint256 _stake) public
    {
        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }

  
    function stakeOf(address _stakeholder) public view returns(uint256)
    {
        return stakes[_stakeholder];
    }


    function totalStakes() public view returns(uint256)
    {
        uint256 _totalStakes = 0;
        for (uint256 i = 0; i < stakeholders.length; i++ )
        {
            _totalStakes = _totalStakes.add(stakes[stakeholders[i]]);
        }
        return _totalStakes;
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



    function rewardOf(address _stakeholder) public view returns(uint256)
    {
        return rewards[_stakeholder];
    }

    function div(uint256 a, uint256 c) internal pure returns (uint256) 
    {
            require(c > 0);
            return a / c;
    }



    function calculateReward(address _stakeholder, uint b) public view returns(uint256)
    {
        b = div (10000, 356);
        rewardPerDay  = (div (stake, _totalStakes)) * b;
        return stakes[_stakeholder] / 100;
    }


    function distributeRewards() public
    {
        for (uint256 i = 0; i < stakeholders.length; i += 1)
        {
            address stakeholder = stakeholders[i];
            uint256 reward = calculateReward(stakeholder);
            rewards[stakeholder] = rewards[stakeholder].add(reward);
        }
    }

    function claimReward() public
    {
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
    }
}
