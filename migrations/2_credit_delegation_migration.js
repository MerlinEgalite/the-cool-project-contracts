const CreditDelegation = artifacts.require("CreditDelegation")

module.exports = function (deployer) {
  deployer.deploy(CreditDelegation)
}
