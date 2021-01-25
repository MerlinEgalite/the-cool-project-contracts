const SimpleCreditDelegation = artifacts.require("SimpleCreditDelegation")

module.exports = function (deployer) {
  deployer.deploy(SimpleCreditDelegation)
}
