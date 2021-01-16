// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

/// @title Voting with delegation.
contract Ballot {

	struct Voter {
		uint weight;
		mapping(address => bool) voted;
		address delegate;
		uint balance;
	}

	struct Project {
		bytes32 projectName;
		uint amountNeeded;
		uint voteCount;
	}

	// Total amount of collateral deposited in the pool by users of the dapp
	uint256 totalDeposited;

	mapping(address => Voter) public voters;
	mapping(address => Project) public projects;

	mapping(address => uint256) public borrowed;

	// Maybe add a way to allow some projects to propose a proposal or not
	function addProject(bytes32 projectName, address projectAddress, uint256 amountNeeded) public {
		require(msg.sender == projectAddress, "");
		projects[projectAddress] = Project({
			projectName: projectName,
			amountNeeded: amountNeeded,
			voteCount: 0
		});
	}

	function hasRightToVote(address sender) public {
		Voter storage voter = voters[sender];
		require(
			voter.balance > 0,
			"Only persons who have collateral in the pool can vote"
		);
		require(voter.weight == 0);
		voter.weight = (voter.balance * 100) / totalDeposited;
	}

	// function delegate(address to) public {
	// 	Voter storage sender = voters[msg.sender];
	// 	require(!sender.voted, "You already voted.");

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

	function vote(address projectAddress) public {
		hasRightToVote(msg.sender);
		Voter storage sender = voters[msg.sender];
		require(sender.weight != 0, "Has no right to vote");
		require(!sender.voted[projectAddress], "Already voted.");
		sender.voted[projectAddress] = true;

		projects[projectAddress].voteCount += sender.weight;
	}

	function canBorrow(address projectAddress) public view returns(bool) {
		return projects[projectAddress].voteCount > 66;
	}

	function checkProjectAllowance(address projectAddress) public view returns(uint256) {
		if (canBorrow(projectAddress)) {
			return projects[projectAddress].amountNeeded;
		} else {
			return 0;
		}
	}
}