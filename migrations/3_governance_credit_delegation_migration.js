const GovernanceCreditDelegation = artifacts.require("GovernanceCreditDelegation")

module.exports = function (deployer) {
  deployer.deploy(GovernanceCreditDelegation)
}
