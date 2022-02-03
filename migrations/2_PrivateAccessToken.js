const PrivateAccessToken = artifacts.require("PrivateAccessToken");

module.exports = function (deployer){
  deployer.deploy(PrivateAccessToken, "SSN", "URI");
};