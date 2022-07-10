const PrivateAccessToken = artifacts.require("PrivateAccessToken");
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
  } = require('@openzeppelin/test-helpers');

//Unit Testing on Multi Sig Contract
// Blank Vote
contract(PrivateAccessToken, (accounts) => {
    let Token = null;

    before( async() => {
        Token = await PrivateAccessToken.deployed("TestData","test 1",{from: accounts[0]});
    });
    it("Launch Contract", async() =>  {
        assert(await Token.address !== '');
    })
    it("check viewData", async() =>  {
        let sendToken = await Token.ViewData()
        assert(sendToken ===  "TestData");
    })
    it("check viewStatus", async() =>  {
        let status = await Token.ViewStatus()
        assert.equal(status.toNumber(), 1);
    })
    it("check wrong person has the token", async() =>  {
        let status = await Token.ViewStatus({from: accounts[1]})
        assert.equal(status.toNumber(), 0);
    })
    it("check to see if seperate person can see", async() =>  {
        await expectRevert.unspecified(Token.ViewData({from: accounts[1]}), "failingStatement");
    })
})