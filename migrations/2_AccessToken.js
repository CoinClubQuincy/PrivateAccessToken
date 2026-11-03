const PrivateAccessToken = artifacts.require("PrivateAccessToken");

module.exports = function (deployer) {
  deployer.deploy(PrivateAccessToken,web3.utils.keccak256("salted document"),"ipfs://encrypted-copy","test");
};