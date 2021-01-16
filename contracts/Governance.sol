// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import { SafeMath } from "./math/SafeMath.sol";

/**
	* @title Governance contract
	**/
contract Governance {
	using SafeMath for uint256;

	struct Voter {
		uint weight;
		mapping(address => bool) voted;
		address delegate;
	}

	struct Project {
		bytes32 projectName;
		uint amountNeeded;
		uint voteCount;
	}

	// Total amount of collateral deposited in the pool by users of the dapp
	uint256 totalAmountDeposited;

	mapping(address => Voter) public voters;
	mapping(address => Project) public projects;
	mapping(address => uint256) public borrowed;
	mapping(address => uint256) public amountsDeposited;

	address[] public projectAddresses;

	/**
		* @dev Adds a project proposal to the vote
		* @param projectName The name of the project
		* @param projectAddress The address of the project
		* @param amountNeeded Amount needed for the project
		*  Maybe add a way to allow some projects to propose a proposal or not
		**/
	function addProjectProposal(bytes32 projectName, address projectAddress, uint256 amountNeeded) public {
		require(msg.sender == projectAddress, "Only the owner of the project can propose the project to vote.");
		projects[projectAddress] = Project({
			projectName: projectName,
			amountNeeded: amountNeeded,
			voteCount: 0
		});
		projectAddresses.push(projectAddress);
	}

	/**
		* @dev Updates a project porposal to the vote
		* @param projectAddress The address of the project
		* @param amountNeeded Amount needed for the project
		*  Maybe add a way to allow some projects to propose a proposal or not
		**/
	function updateProjectProposal(address projectAddress, uint256 amountNeeded) public {
		// TODO: check if former ballot has passed or not
		require(msg.sender == projectAddress, "Only the owner of the project can propose the project to vote.");
		Project storage project = projects[projectAddress];
		project.amountNeeded = amountNeeded;
		project.voteCount = 0;
	}

	/**
		* @dev Checks whether sender can vote or not
		* @param sender The address of the account to check
		**/
	function hasRightToVote(address sender) public returns (bool) {
		Voter storage voter = voters[sender];
		voter.weight = amountsDeposited[sender].mul(100).div(totalAmountDeposited);
		return (amountsDeposited[sender] > 0 && voter.weight != 0);
	}

	// TODO: Add delegation
	// function delegate(address to) public {
	// 	Voter storage sender = voters[msg.sender];
	// 	// require(!sender.voted, "You already voted.");
	// 	require(to != msg.sender, "Self-delegation is disallowed.");

	// 	while (voters[to].delegate != address(0)) {
	// 		to = voters[to].delegate;
	// 		require(to != msg.sender, "Found loop in delegation.");
	// 	}

	// 	sender.voted = true;
	// 	sender.delegate = to;
	// 	Voter storage delegate_ = voters[to];
	// 	if (delegate_.voted[projectAddress]) {
	// 		proposals[delegate_.vote].voteCount += sender.weight;
	// 	} else {
	// 		delegate_.weight += sender.weight;
	// 	}
	// }

	/**
		* @dev Votes for 'YES' a project
		* @param projectAddress The address of the project to vote for
		**/
	function vote(address projectAddress) public {
		require(hasRightToVote(msg.sender), "Has no right to vote");
		Voter storage sender = voters[msg.sender];
		require(!sender.voted[projectAddress], "Already voted.");
		sender.voted[projectAddress] = true;

		Project storage project = projects[projectAddress];
		project.voteCount += sender.weight;
	}

	/**
		* @dev Checks the project is allowed to borrow an asset
		* @param projectAddress The address of the project
		**/
	function canBorrow(address projectAddress) public view returns(bool) {
		// TODO: improve voting system
		return projects[projectAddress].voteCount > 67;
	}

	/**
		* @dev Checks the project allowance in DAI
		* @param projectAddress The address of the project
		**/
	function getProjectAllowance(address projectAddress) public view returns(uint256) {
		if (canBorrow(projectAddress)) {
			Project storage project = projects[projectAddress];
			return project.amountNeeded;
		} else {
			return 0;
		}
	}
}