const CreditDelegation = artifacts.require('CreditDelegation.sol')

contract('CreditDelegation', async () => {
	const [admin, alice, bob] = accounts
	const daiAddress = '0xff795577d9ac8bd7d90ee22b6c1703490b6512fd'
	let creditDelegationInstance

	beforeEach(async function () {
		creditDelegationInstance = await CreditDelegation.new({ from: admin })
	})

	it('should', async () => {
		creditDelegationInstance.depositCollateral(daiAddress, 1, true)
	})

})