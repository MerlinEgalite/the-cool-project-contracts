// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.12;

import { ILendingPool, IProtocolDataProvider, IStableDebtToken, ILendingPoolAddressesProvider } from "./Interfaces.sol";
import { IERC20 } from "./token/ERC20/IERC20.sol";
import { SafeERC20 } from "./token/ERC20/SafeERC20.sol";

/**
	* @title SimpleCreditDelegation contract
	**/
contract SimpleCreditDelegation {
	using SafeERC20 for IERC20;

	ILendingPoolAddressesProvider provider;
	ILendingPool lendingPool;
	IProtocolDataProvider constant dataProvider = IProtocolDataProvider(address(0x744C1aaA95232EeF8A9994C4E0b3a89659D9AB79));

	address owner;

	constructor () public {
		// Kovan
		provider = ILendingPoolAddressesProvider(address(0x652B2937Efd0B5beA1c8d54293FC1289672AFC6b));
		lendingPool = ILendingPool(provider.getLendingPool());
		owner = msg.sender;
	}

	/**
		* Deposits collateral into the Aave, to enable credit delegation
		* This would be called by the delegator.
		* @param asset The asset to be deposited as collateral
		* @param amount The amount to be deposited as collateral
		* @param isPull Whether to pull the funds from the caller, or use funds sent to this contract
		*  User must have approved this contract to pull funds if `isPull` = true
		*
		*/
	function depositCollateral(address asset, uint256 amount, bool isPull) public {
		if (isPull) {
			IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);
		}
		IERC20(asset).safeApprove(address(lendingPool), amount);
		lendingPool.deposit(asset, amount, address(this), 0);
	}

	/**
		* Approves the borrower to take an uncollaterised loan
		* @param borrower The borrower of the funds (i.e. delgatee)
		* @param amount The amount the borrower is allowed to borrow (i.e. their line of credit)
		* @param asset The asset they are allowed to borrow
		*
		* Add permissions to this call, e.g. only the owner should be able to approve borrowers!
		*/
	function approveBorrower(address borrower, uint256 amount, address asset) public {
		(, address stableDebtTokenAddress,) = dataProvider.getReserveTokensAddresses(asset);
		IStableDebtToken(stableDebtTokenAddress).approveDelegation(borrower, amount);
	}

	/**
		* Borrows some the uncollaterised loan
		* @param amount The amount the borrower is allowed to borrow (i.e. their line of credit)
		* @param asset The asset they are allowed to borrow
		*/
	function borrowCredit(uint256 amount, address asset) public {
		lendingPool.borrow(asset, amount, 1, 0, address(this));
	}

	/**
		* Checks allowance for loan
		* @param delegator The delegator of the funds
		* @param delegatee The delegatee of the funds
		* @param asset The asset they are allowed to borrow
		*/
	function checkAllowance(address delegator, address delegatee, address asset) public view returns(uint256) {
		(, address stableDebtTokenAddress,) = dataProvider.getReserveTokensAddresses(asset);
		return IStableDebtToken(stableDebtTokenAddress).borrowAllowance(delegator, delegatee);
	}

	/**
		* Repay an uncollaterised loan
		* @param amount The amount to repay
		* @param asset The asset to be repaid
		*
		* User calling this function must have approved this contract with an allowance to transfer the tokens
		*
		* You should keep internal accounting of borrowers, if your contract will have multiple borrowers
		*/
	function repayBorrower(uint256 amount, address asset) public {
		IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);
		IERC20(asset).safeApprove(address(lendingPool), amount);
		lendingPool.repay(asset, amount, 1, address(this));
	}

	/**
		* Withdraw all of a collateral as the underlying asset, if no outstanding loans delegated
		* @param asset The underlying asset to withdraw
		*
		* Add permissions to this call, e.g. only the owner should be able to withdraw the collateral!
		*/
	function withdrawCollateral(address asset) public {
		(address aTokenAddress,,) = dataProvider.getReserveTokensAddresses(asset);
		uint256 assetBalance = IERC20(aTokenAddress).balanceOf(address(this));
		lendingPool.withdraw(asset, assetBalance, owner);
	}
}